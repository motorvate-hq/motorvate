//
//  CustomerService.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-06-01.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

typealias CustomerResponseHandler = (Result<Customer, NetworkResponse>) -> Void
typealias CustomerListResponseHandler = (Result<[Customer], NetworkResponse>) -> Void

protocol CustomerServiceProtocol {
    func getCustomer(withId: String, completion: @escaping CustomerResponseHandler)
    func getCustomerList(completion: @escaping CustomerListResponseHandler)
}

struct CustomerService: CustomerServiceProtocol {
    fileprivate let router: Router<CustomerRoute>

    init(_ router: Router<CustomerRoute> = Router<CustomerRoute>()) {
        self.router = router
    }

    func getCustomer(withId: String, completion: @escaping CustomerResponseHandler) {
        router.request(.getCustomer(withId: withId), completion: { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        })
    }

    func getCustomerList(completion: @escaping CustomerListResponseHandler) {
        guard let shopId = UserSession.shared.shopID else { return }
        router.request(.getCustomerList(urlParams: ["shopID": shopId])) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
}

fileprivate extension CustomerService {
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping CustomerResponseHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(Customer.self, from: data)
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

    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping CustomerListResponseHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode([Customer].self, from: data)
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
}
