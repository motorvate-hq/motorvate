//
//  UserService.swift
//  Motorvate
//
//  Created by Emmanuel on 2/24/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation
typealias UserResponseHandler = (Result<User, NetworkResponse>) -> Void
typealias ShopResponseHandler = (Result<Bool, NetworkResponse>) -> Void
typealias ResponseHandle = (Result<Bool, NetworkResponse>) -> Void
typealias BoolResponseHandler = (Bool) -> Void

protocol UserServiceProtocol {
    func updateAPNsToken(token: String, for userID: String)
    func inviteUser(params: Parameters, completion: @escaping (Result<Bool, NetworkResponse>) -> Void)
    func getUser(by userID: String, completion: @escaping UserResponseHandler)
    func getShop(shopID: String, completion: @escaping (Result<Bool, NetworkResponse>) -> Void)
    func updateUser(with userID: String, params: Parameters, completion: @escaping (Bool) -> Void)
    func createShop(params: Parameters, completion: @escaping (Result<Bool, NetworkResponse>) -> Void)
    func deleteAccount(for userId: String) async -> Bool
    
    func createScheduledService(with request: CreateScheduledServiceRequest, completion: @escaping BooleanCompletion)
}

struct UserService {
    enum Constants {
        static let encodedShopKey = "encodedShopKey"
        static let encodedUserKey = "encodedUserKey"
    }

    fileprivate let router: Router<UserRoute>

    init(_ router: Router<UserRoute> = Router<UserRoute>()) {
        self.router = router
    }
}

// MARK: UserServiceProtocol
extension UserService: UserServiceProtocol {
    func getUser(by userID: String, completion: @escaping UserResponseHandler) {
        router.request(.get(userID: userID)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                switch result {
                case .success(let data):
                    UDRepository.shared.insert(item: data, for: Constants.encodedUserKey)
                    CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
                    if let shopId = UDRepository.shared.getItem(User.self, for: Constants.encodedUserKey)?.shopID {
                        self.getShop(shopID: shopId) { _ in }
                    }
                    do {
                        let model = try JSONDecoder().decode(User.self, from: data)
                        completion(.success(model))
                    } catch {
                        print("Error \(error)")
                        completion(.failure(.unableToDecode))
                    }
                case .failure(let error):
                    print("LOG ERROR getUser error ----> \(String(describing: error))")
                    completion(.failure(.failed))
                }
            }
        }
    }

    func updateUser(with userID: String, params: Parameters, completion: @escaping (Bool) -> Void) {
        router.request(.update(userID: userID, params: params)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                var success = false
                switch result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(User.self, from: data)
                        print(model)
                        success = true
                    } catch {
                        print("Error \(error)")
                        success = false
                    }
                case .failure(let error):
                    print("Error \(error)")
                    success = false
                }

                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }

    func updateAPNsToken(token: String, for userID: String) {
        let param: Parameters = ["token": token]
        router.request(.deviceToken(userID: userID, params: param)) { (_, response, _) in
            guard let urlResponse = response as? HTTPURLResponse else {
                print("Failed to cast to HTTPURLResponse")
                return
            }
            
            let response = HTTPNetworkResponse.handleNetworkResponse(urlResponse)
            
            // Do some logging here if response failed
            print("Update device push token response: \(response)")            
        }
    }

    func inviteUser(params: Parameters, completion: @escaping (Result<Bool, NetworkResponse>) -> Void) {
        router.request(.invite(param: params)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        AnalyticsManager.logEvent(.teamMemberAdded)
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func getShop(shopID: String, completion: @escaping (Result<Bool, NetworkResponse>) -> Void) {
        router.request(.getShop(shopID: shopID)) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }

    func createShop(params: Parameters, completion: @escaping (Result<Bool, NetworkResponse>) -> Void) {
        router.request(.createShop(param: params)) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }

    func deleteAccount(for userId: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            router.request(.delete(userID: userId)) { data, response, error in
                if error != nil {
                    continuation.resume(returning: false)
                }
                if let _response = (response as? HTTPURLResponse), (200...299).contains(_response.statusCode) {
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func createScheduledService(with request: CreateScheduledServiceRequest, completion: @escaping BooleanCompletion) {
        router.request(.createScheduledService(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                switch result {
                case .success(let success):
                    completion(success)
                case .failure(let error):
                    completion(false)
                }
            }
        }
    }
}

extension UserService {
    func handleResponse (_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping ShopResponseHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    UDRepository.shared.insert(item: data, for: Constants.encodedShopKey)
                    completion(.success(true))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
