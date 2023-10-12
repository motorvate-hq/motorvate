//
//  Router.swift
//  Motorvate
//
//  Created by Emmanuel on 6/8/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

enum APIServer {
    case motorvate
    case plateRecognizer
    case carsXe
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ endPoint: EndPoint, server: APIServer = .motorvate, completion: @escaping NetworkingCompletion) {
        
        switch server {
        case .motorvate:
            Authenticator.default.authorizationToken { [weak self] (token) in
                guard let strongSelf = self else { return }
                guard let authorizationToken = token else {
                    print("Log error authorizationTokenUnavailable, forcing logout")
                    DispatchQueue.main.async { NotificationCenter.default.post(name: .ForceLogoutAuthorizationTokenUnavailable, object: nil) }
                    completion(nil, nil, NetworkResponse.authorizationTokenUnavailable)
                    return
                }
                print("LOG -> authorizationToken \(authorizationToken)")
                strongSelf.performRequest(endPoint, completion: completion, authorizationToken: authorizationToken)
            }
        case .plateRecognizer:
            performRequest(endPoint, baseUrlType: .plateRecognizer, completion: completion, authorizationToken: Environment.plateRecognizerAuthToken)
        case .carsXe:
            performRequest(endPoint, baseUrlType: .carsXe, completion: completion, authorizationToken: nil)
        }
    }
    
    private func performRequest(
        _ endPoint: EndPoint,
        baseUrlType: BaseUrlType = .motorvate,
        completion: @escaping NetworkingCompletion,
        authorizationToken: String?
    ) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(for: endPoint, baseUrlType: baseUrlType, authorizationToken: authorizationToken)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}

private extension Router {
    
    /// Returns an instance of `URLRequest`
    ///
    /// - parameter: endPoint An instance of `EndPointType` that configures a URLRequest with headers, query and body               params
    func buildRequest(for endPoint: EndPoint, baseUrlType: BaseUrlType = .motorvate, authorizationToken: String?) throws -> URLRequest {
        
        print("URL:", "\(endPoint.httpMethod.rawValue)", endPoint.baseUrl(baseUrlType).appendingPathComponent(endPoint.path))
        
        var request = URLRequest(url: endPoint.baseUrl(baseUrlType).appendingPathComponent(endPoint.path), cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        request.httpMethod = endPoint.httpMethod.rawValue
        
        do {
            switch endPoint.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(bodyParameters: let bodyParameters, urlParameters: let urlParameters):
                print("bodyParameters:", bodyParameters as Any, "urlParameters:", urlParameters as Any)
                try encode(with: bodyParameters, urlParams: urlParameters, request: &request)
            case .requestParametersAndHeaders(bodyParams: let bodyParameters, urlParams: let urlParameters, additionalHeaders: let additionalParams):
                addAdditionalHeaders(additionalParams, request: &request)
                try encode(with: bodyParameters, urlParams: urlParameters, request: &request)
            }
            
            if let authorizationToken = authorizationToken {
                let authorization: HTTPHeaders = ["Authorization": "\(authorizationToken)"]
                addAdditionalHeaders(authorization, request: &request)
            }
            return request
            
        } catch {
            throw error
        }
    }
    
    /// Encodes body and  query parameters if applicable and appends result onto the request
    ///
    /// - parameter: bodyParams The body params dictionary to be appended
    /// - parameter: urlParams The query params values to be appened
    /// - parameter: request An instance of `URLRequest`
    func encode(with bodyParams: Parameters?, urlParams: Parameters?, request: inout URLRequest) throws {
        do {
            if let body = bodyParams {
                try JSONParameterEncoder.encode(urlRquest: &request, with: body)
            }
            
            if let queryParams = urlParams {
                try URLParameterEncoder.encode(urlRquest: &request, with: queryParams)
            }
        } catch {
            throw error
        }
    }
    
    /// Appends additional headers params to the `URLRequest`
    ///
    /// - parameter: additionalHeaders An instance of `HTTPHeaders` to be appended on the request
    /// - parameter: request An instance of the `URLRequest`
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
