//
//  StripeService.swift
//  Motorvate
//
//  Created by Nikita Benin on 12.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

typealias HasConnectedStripeResponseHandler = (Result<HasConnectedStripeResponse, NetworkResponse>) -> Void
typealias StripeResponseAccountIdHandler = (Result<CreateStripeAccountResponse, NetworkResponse>) -> Void
typealias StripeResponseLinkHandler = (Result<CreateStripeAccountLinkResponse, NetworkResponse>) -> Void
typealias GetStripeAccountHandler = (Result<GetStripeAccountResponse, NetworkResponse>) -> Void
typealias GetStripeLoginLinkHandler = (Result<GetStripeLoginLinkResponse, NetworkResponse>) -> Void

protocol StripeServiceProtocol {
    func hasConnectedStripe(request: HasConnectedStripeRequest, completion: @escaping HasConnectedStripeResponseHandler)
    func createAccount(request: CreateStripeAccountRequest, completion: @escaping StripeResponseAccountIdHandler)
    func createAccountLink(request: CreateStripeAccountLinkRequest, completion: @escaping StripeResponseLinkHandler)
    func getStripeAccount(request: GetStripeAccountRequest, completion: @escaping GetStripeAccountHandler)
    func getStripeLoginLink(request: GetStripeAccountRequest, completion: @escaping GetStripeLoginLinkHandler)
}

struct StripeService: StripeServiceProtocol {
    
    fileprivate let router: Router<StripeRoute>

    init(_ router: Router<StripeRoute> = Router<StripeRoute>()) {
        self.router = router
    }
    
    func hasConnectedStripe(request: HasConnectedStripeRequest, completion: @escaping HasConnectedStripeResponseHandler) {
        router.request(.hasConnectedStripe(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func createAccount(request: CreateStripeAccountRequest, completion: @escaping StripeResponseAccountIdHandler) {
        router.request(.createAccount(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func createAccountLink(request: CreateStripeAccountLinkRequest, completion: @escaping StripeResponseLinkHandler) {
        router.request(.createAccountLink(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func getStripeAccount(request: GetStripeAccountRequest, completion: @escaping GetStripeAccountHandler) {
        router.request(.getStripeAccount(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func getStripeLoginLink(request: GetStripeAccountRequest, completion: @escaping GetStripeLoginLinkHandler) {
        router.request(.getStripeLoginLink(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
}

fileprivate extension StripeService {
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping HasConnectedStripeResponseHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(HasConnectedStripeResponse.self, from: data)
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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping StripeResponseAccountIdHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(CreateStripeAccountResponse.self, from: data)
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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping StripeResponseLinkHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(CreateStripeAccountLinkResponse.self, from: data)
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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping GetStripeAccountHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(GetStripeAccountResponse.self, from: data)
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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping GetStripeLoginLinkHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(GetStripeLoginLinkResponse.self, from: data)
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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
