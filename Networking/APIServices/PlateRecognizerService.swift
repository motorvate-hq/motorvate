//
//  PlateRecognizerService.swift
//  Motorvate
//
//  Created by Nikita Benin on 19.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

typealias PlateReaderHandler = (Result<PlateReaderResponse, NetworkResponse>) -> Void

protocol PlateRecognizerServiceProtocol {
    func plateReader(request: PlateReaderRequest, completion: @escaping PlateReaderHandler)
}

struct PlateRecognizerService: PlateRecognizerServiceProtocol {
    
    fileprivate let router: Router<PlateRecognizerRoute>

    init(_ router: Router<PlateRecognizerRoute> = Router<PlateRecognizerRoute>()) {
        self.router = router
    }
    
    func plateReader(request: PlateReaderRequest, completion: @escaping PlateReaderHandler) {
        router.request(.plateReader(request: request), server: .plateRecognizer) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping PlateReaderHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(PlateReaderResponse.self, from: data)
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
