//
//  ChatService.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-04-19.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

typealias ChatHistoryResponseHandler = (Result<ChatHistory, NetworkResponse>) -> Void
typealias ChatHistoriesReponseHandler = (Result<[ChatHistory], NetworkResponse>) -> Void

protocol ChatServiceProtocol {
    func getHistory(shopID: String, customerID: String, completion: @escaping ChatHistoryResponseHandler)
    func getHistories(shopID: String, completion: @escaping ChatHistoriesReponseHandler)
    func send(message: String, from sender: ChatService.SenderConfiguration, to receiver: String, completion: @escaping ChatHistoryResponseHandler)
    func updateReadStatus(request: UpdateReadStatusRequest, completion: @escaping ChatHistoryResponseHandler)
}

struct ChatService: ChatServiceProtocol {
    
    fileprivate let router: Router<ChatRoute>
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        return dateFormatter
    }()

    init(_ router: Router<ChatRoute> = Router<ChatRoute>()) {
        self.router = router
    }

    func getHistory(shopID: String, customerID: String, completion: @escaping ChatHistoryResponseHandler) {
        router.request(.getHistory(shopID: shopID, customerID: customerID)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }

    func getHistories(shopID: String, completion: @escaping ChatHistoriesReponseHandler) {
        router.request(.getHistories(shopId: shopID)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }

    func send(message: String, from sender: SenderConfiguration, to receiver: String, completion: @escaping ChatHistoryResponseHandler) {
        let params: Parameters = ["text": message, "topicArn": sender.topicArn, "from": sender.shopID]
        router.request(.sendMessage(shopID: sender.shopID, customerID: receiver, params: params)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func updateReadStatus(request: UpdateReadStatusRequest, completion: @escaping ChatHistoryResponseHandler) {
        router.request(.updateReadStatus(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
}

fileprivate extension ChatService {
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping ChatHistoryResponseHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(ChatHistory.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(.failure(.unableToDecode))
                    }
                }
            case .failure(let error):
                print("LOG -----> HTTPNetworkResponse error \(error.self)")
                completion(.failure(error))
            }
        }
    }

    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping ChatHistoriesReponseHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode([ChatHistory].self, from: data)
                    let sortedModel = sortChatHistoriesByDate(chatHistories: model)
                    DispatchQueue.main.async {
                        completion(.success(sortedModel))
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(.failure(.unableToDecode))
                    }
                }
            case .failure(let error):
                print("LOG -----> HTTPNetworkResponse error \(error.self)")
                completion(.failure(error))
            }
        }
    }
    
    private func sortChatHistoriesByDate(chatHistories: [ChatHistory]) -> [ChatHistory] {
        return chatHistories.sorted(by: { (chatOne, chatTwo) -> Bool in
            guard let createDateOne = chatOne.chat.last?.createDate,
                  let createDateTwo = chatTwo.chat.last?.createDate,
                  let dateOne = dateFormatter.date(from: createDateOne),
                  let dateTwo = dateFormatter.date(from: createDateTwo)
                  else { return false }
            return dateOne > dateTwo
        })
    }
}

extension ChatService {
    struct SenderConfiguration {
        let shopID: String
        let topicArn: String
    }
}
