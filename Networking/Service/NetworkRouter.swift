//
//  NetworkRouter.swift
//  Motorvate
//
//  Created by Emmanuel on 6/8/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

public enum NetworkResponse: Error, LocalizedError {
    case success
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case unableToHandleURLResponse
    case authorizationTokenUnavailable
    case invalidData
    case serverError(message: String)
    
    var message: String {
        switch self {
        case .success:
            return "success"
        case .authenticationError:
            return "You need to be authenticated first"
        case .badRequest:
            return "Bad request"
        case .outdated:
            return "The url you requested is outdated"
        case .failed:
            return "Network request failed"
        case .noData:
            return "Response returned with no data to decode"
        case .unableToDecode:
            return "We could not decoded the response"
        case .unableToHandleURLResponse:
            return "We could not cast to HTTPURLResponse"
        case .authorizationTokenUnavailable:
            return "authorizationTokenUnavailable"
        case .invalidData:
            return "invalidData"
        case .serverError(let message):
            return message
        }
    }
    
    public var errorDescription: String? {
        return self.message
    }
}

typealias NetworkingCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
typealias BooleanCompletion = (Bool) -> Void

/// Protocol that defines a netweork request
protocol NetworkRouter {
    associatedtype EndPoint: EndPointType
    func request(_ endPoint: EndPoint, server: APIServer, completion: @escaping NetworkingCompletion)
    func cancel()
}

struct HTTPNetworkResponse {

    typealias ResponseData = (Result<Data, NetworkResponse>) -> Void

    static func validateResponseData(for data: Data?, response: URLResponse?, error: Error?, completion: @escaping ResponseData) {

        /// Error occured
        if error != nil {
            completion(.failure(.badRequest))
            return
        }

        /// Cast to HTTPURLResponse
        guard let urlResponse = response as? HTTPURLResponse else {
            completion(.failure(.unableToHandleURLResponse))
            return
        }

        let httpResponse = HTTPNetworkResponse.handleNetworkResponse(urlResponse)
        switch httpResponse {
        case .success:
            guard let responseData = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(responseData))
        case .badRequest:
            guard let responseData = data else {
                completion(.failure(.badRequest))
                return
            }
            let error = InviteMemberErrorResponse(data: responseData)
            completion(.failure(.serverError(message: error.message)))
        default:
            print("validateResponseData error => \(urlResponse)")
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print("validateResponseData data => \(str)")
            }
            completion(.failure(httpResponse))
        }
    }

    static func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponse {
        switch response.statusCode {
        case 200...209:
            return .success
        case 401...500:
            return .authenticationError
        case 501...599:
            return .badRequest
        case 600:
            return .outdated
        default: return .failed
        }
    }
}
