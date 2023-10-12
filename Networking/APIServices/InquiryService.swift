//
//  InquiryService.swift
//  Motorvate
//
//  Created by Emmanuel on 5/2/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

typealias InquiryPersistingCompletion = (Result<Inquiry, Error>) -> Void

protocol InquiryServiceProviding {
    func createInquiry(with request: CreateInquiryRequest, completion: @escaping InquiryPersistingCompletion)
    func allInquiries(for shopID: String, completion: @escaping (Result<[Inquiry], NetworkResponse>) -> Void)
    func sendFormLink(with request: SendFormLinkRequest, completion: @escaping BooleanCompletion)
    func getFormInfo(with request: GetFormInfoRequest, completion: @escaping ((Result<FormInfo, NetworkResponse>) -> Void))
    func deleteInquiry(with inquiryId: String, completion: @escaping BooleanCompletion)
}

struct InquiryService: InquiryServiceProviding {
    func sendFormLink(with request: SendFormLinkRequest, completion: @escaping BooleanCompletion) {
        router.request(.sendFormLink(request: request)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        completion(true)
                    case .failure:
                        completion(false)
                    }
                }
            }
        }
    }
    
    func getFormInfo(with request: GetFormInfoRequest, completion: @escaping ((Result<FormInfo, NetworkResponse>) -> Void)) {
        router.request(.getFormInfo(request: request)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        do {
                            let model = try JSONDecoder().decode(FormInfo.self, from: data)
                            DispatchQueue.main.async {
                                completion(.success(model))
                            }
                        } catch let error as NSError {
                            print("LOG -----> endpoint: allJobs HTTPNetworkResponse error \(error)")
                            DispatchQueue.main.async {
                                completion(.failure(.unableToDecode))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    fileprivate let router: Router<InquiryRoute>

    init(_ router: Router<InquiryRoute> = Router<InquiryRoute>()) {
        self.router = router
    }

    func createInquiry(with request: CreateInquiryRequest, completion: @escaping InquiryPersistingCompletion) {
//        print("createInquiry \(parameters)")
//        let request = CreateInquiryRequest()
        router.request(.createInquiry(request: request)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        do {
                            let model = try JSONDecoder().decode(Inquiry.self, from: data)
                            
                            completion(.success(model))
                        } catch let error {
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func allInquiries(for shopID: String, completion: @escaping (Result<[Inquiry], NetworkResponse>) -> Void) {
        router.request(.allInquiries(shopID: shopID)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode([Inquiry].self, from: data).filter { $0.status == .open }
                        DispatchQueue.main.async {
                            completion(.success(model))
                        }
                    } catch let error as NSError {
                        print("LOG -----> endpoint: allInquiries HTTPNetworkResponse error \(error)")
                        DispatchQueue.main.async {
                            completion(.failure(.unableToDecode))
                        }
                    }
                case .failure(let error):
                    print("LOG -----> endpoint: allInquiries HTTPNetworkResponse error \(error.message)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func deleteInquiry(with inquiryId: String, completion: @escaping BooleanCompletion) {
        router.request(.delete(inquiryId: inquiryId)) { data, response, error in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        completion(true)
                    case .failure:
                        completion(false)
                    }
                }
            }
        }
    }
}
