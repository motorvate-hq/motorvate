//
//  JobService.swift
//  Motorvate
//
//  Created by Emmanuel on 2/9/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

typealias JobResponseHandler = (Result<Job, NetworkResponse>) -> Void
typealias InquiryResponseHandler = (Result<Inquiry, NetworkResponse>) -> Void
typealias ScheduledServiceResponseHandler = (Result<Bool, NetworkResponse>) -> Void
typealias SendEstimationLinkReponseHandler = (Result<ChatHistory, NetworkResponse>) -> Void
typealias GetPreviewLinkResponseHandler = (Result<GetEstimationPreviewLinkResponse, NetworkResponse>) -> Void

protocol JobServiceProtocol {
    func create(with parameters: Parameters, completion: @escaping JobResponseHandler)
    func update(jobID: String, parameters: Parameters, completion: @escaping JobResponseHandler)
    func allJobs(with parameters: Parameters, completion: @escaping (Result<[Job], NetworkResponse>) -> Void)
    func getJob(jobID: String, completion: @escaping JobResponseHandler)
    func decodeVehicle(vin: String, jobID: String, completion: @escaping JobResponseHandler)
    func getUploadURL(for metadata: OnboardViewModel.FileMetadata, completion: @escaping (Result<OnboardViewModel.File, NetworkResponse>) -> Void)
    
    func addUpdateJobDetails(request: AddUpdateJobDetailsRequest, completion: @escaping JobResponseHandler)
    func deleteJobDetails(request: DeleteJobDetailsRequest, completion: @escaping JobResponseHandler)
    func sendPaymentInvoiceLink(request: SendPaymentInvoiceRequest, completion: @escaping (Result<ChatHistory, NetworkResponse>) -> Void)
    func getPaymentInvoicePreviewLink(request: PaymentInvoicePreviewLinkRequest, completion: @escaping GetPreviewLinkResponseHandler)
    
    func addUpdateInquiryDetails(request: AddUpdateInquiryRequest, completion: @escaping InquiryResponseHandler)
    func deleteInquiryDetails(request: DeleteInquiryDetailsRequest, completion: @escaping InquiryResponseHandler)
    func sendEstimationLink(request: SendEstimationLinkRequest, completion: @escaping SendEstimationLinkReponseHandler)
    func getEstimationPreviewLink(request: GetEstimationPreviewLinkRequest, completion: @escaping GetPreviewLinkResponseHandler)
    
    func getScheduledService(with parameters: Parameters, completion: @escaping (Result<[ScheduledService], NetworkResponse>) -> Void)
}

struct JobService: JobServiceProtocol {
    
    fileprivate let router: Router<JobRoute>

    init(_ router: Router<JobRoute> = Router<JobRoute>()) {
        self.router = router
    }

    func create(with parameters: Parameters, completion: @escaping JobResponseHandler) {
        router.request(.createJob(parameters: parameters)) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }

    func update(jobID: String, parameters: Parameters, completion: @escaping JobResponseHandler) {
        router.request(.updateJob(jobID: jobID, parameters: parameters)) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }

    func allJobs(with parameters: Parameters, completion: @escaping (Result<[Job], NetworkResponse>) -> Void) {
        router.request(.allJobs(parameters: parameters)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode([Job].self, from: data)
                            .sorted(by: { (jobOne, jobTwo) -> Bool in
                                let df = DateFormatter()
                                let timestampOne = df.decodeServerDate(from: jobOne.createdAt ?? "")
                                let timestampTwo = df.decodeServerDate(from: jobTwo.createdAt ?? "")
                                return timestampOne > timestampTwo
                            })
                        
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
                    print("LOG -----> endpoint: allJobs HTTPNetworkResponse error \(error.message)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func getJob(jobID: String, completion: @escaping JobResponseHandler) {
        router.request(.getJob(jobID: jobID)) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }

    func decodeVehicle(vin: String, jobID: String, completion: @escaping JobResponseHandler) {
        let params: Parameters = ["vin": vin]
        router.request(.scanVin(jobID: jobID, parameters: params)) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }

    func getUploadURL(for metadata: OnboardViewModel.FileMetadata, completion: @escaping (Result<OnboardViewModel.File, NetworkResponse>) -> Void) {
        let params: Parameters = ["filename": metadata.fileName, "type": metadata.type.rawValue]
        router.request(.getUploadURL(jobID: metadata.jobID, parameters: params)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(OnboardViewModel.File.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(model))
                        }
                    } catch let error as NSError {
                        print("LOG -----> endpoint: getUploadURL HTTPNetworkResponse error \(error)")
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
    
    func addUpdateJobDetails(request: AddUpdateJobDetailsRequest, completion: @escaping JobResponseHandler) {
        router.request(.addUpdateJobDetails(parameters: request.dictionary ?? [:])) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }
    
    func deleteJobDetails(request: DeleteJobDetailsRequest, completion: @escaping JobResponseHandler) {
        router.request(.deleteJobDetails(parameters: request.dictionary ?? [:])) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }
    
    func sendPaymentInvoiceLink(request: SendPaymentInvoiceRequest, completion: @escaping (Result<ChatHistory, NetworkResponse>) -> Void) {
        let parameters = request.dictionary ?? [:]
        router.request(.generateJobDetailsToken(parameters: parameters)) { (data, response, error) in
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
    }
    
    func getPaymentInvoicePreviewLink(request: PaymentInvoicePreviewLinkRequest, completion: @escaping GetPreviewLinkResponseHandler) {
        router.request(.getPaymentInvoicePreviewLink(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func addUpdateInquiryDetails(request: AddUpdateInquiryRequest, completion: @escaping InquiryResponseHandler) {
        router.request(.addUpdateInquiryDetails(parameters: request.dictionary ?? [:])) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }
    
    func deleteInquiryDetails(request: DeleteInquiryDetailsRequest, completion: @escaping InquiryResponseHandler) {
        router.request(.deleteInquiryDetails(parameters: request.dictionary ?? [:])) { (data, response, error) in
            self.handleResponse(data, response, error) { (result) in
                completion(result)
            }
        }
    }
    
    func sendEstimationLink(request: SendEstimationLinkRequest, completion: @escaping SendEstimationLinkReponseHandler) {
        router.request(.sendEstimationLink(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func getEstimationPreviewLink(request: GetEstimationPreviewLinkRequest, completion: @escaping GetPreviewLinkResponseHandler) {
        router.request(.getEstimationPreviewLink(request: request)) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func getScheduledService(with parameters: Parameters, completion: @escaping (Result<[ScheduledService], NetworkResponse>) -> Void) {
        router.request(.getScheduledService(parameters: parameters)) { (data, response, error) in
            HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode([ScheduledService].self, from: data)
                            .sorted(by: { (jobOne, jobTwo) -> Bool in
                                let df = DateFormatter()
                                let timestampOne = df.decodeServerDate(from: jobOne.createdAt ?? "")
                                let timestampTwo = df.decodeServerDate(from: jobTwo.createdAt ?? "")
                                return timestampOne > timestampTwo
                            })

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
                    print("LOG -----> endpoint: allJobs HTTPNetworkResponse error \(error.message)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

fileprivate extension JobService {
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping JobResponseHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(Job.self, from: data)
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
                print("LOG -----> handleResponse HTTPNetworkResponse error \(error.self)")
                DispatchQueue.main.async {
                    guard let data = data, String(data: data, encoding: String.Encoding.utf8) == "Could not scan vin" else {
                        completion(.failure(error))
                        return
                    }
                    completion(.failure(NetworkResponse.invalidData))
                }
            }
        }
    }
    
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping InquiryResponseHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(Inquiry.self, from: data)
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
                print("LOG -----> handleResponse HTTPNetworkResponse error \(error.self)")
                DispatchQueue.main.async {
                    guard let data = data, String(data: data, encoding: String.Encoding.utf8) == "Could not scan vin" else {
                        completion(.failure(error))
                        return
                    }
                    completion(.failure(NetworkResponse.invalidData))
                }
            }
        }
    }
    
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping SendEstimationLinkReponseHandler) {
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
    
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping GetPreviewLinkResponseHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(GetEstimationPreviewLinkResponse.self, from: data)
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
