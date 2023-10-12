//
//  CarsXEService.swift
//  Motorvate
//
//  Created by Nikita Benin on 19.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

typealias PlateDecoderHandler = (Result<PlateDecoderResponse, NetworkResponse>) -> Void

protocol CarsXEServiceProtocol {
    func plateDecoder(request: PlateDecoderRequest, completion: @escaping PlateDecoderHandler)
}

struct CarsXEService: CarsXEServiceProtocol {
    
    fileprivate let router: Router<CarsXERoute>

    init(_ router: Router<CarsXERoute> = Router<CarsXERoute>()) {
        self.router = router
    }
    
    func plateDecoder(request: PlateDecoderRequest, completion: @escaping PlateDecoderHandler) {
        router.request(.plateDecoder(request: request), server: .carsXe) { (data, response, error) in
            self.handleResponse(data, response, error) { result in
                completion(result)
            }
        }
    }
    
    func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping PlateDecoderHandler) {
        HTTPNetworkResponse.validateResponseData(for: data, response: response, error: error) { (result) in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(PlateDecoderResponse.self, from: data)
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
