//
//  EndPointType.swift
//  Motorvate
//
//  Created by Emmanuel on 6/8/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

// A protocol that defines a URLRequest with all its components such as query params
protocol EndPointType {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPointType {
    var headers: HTTPHeaders? {
        return [:]
    }
    
    func baseUrl(_ type: BaseUrlType = .motorvate) -> URL {
        if let url = type.url {
            return url
        }
        fatalError("Invalid base URL.")
    }
}

enum BaseUrlType {
    case motorvate
    case plateRecognizer
    case carsXe
    
    var url: URL? {
        switch self {
        case .motorvate:
            return Environment.baseURL
        case .plateRecognizer:
            return URL(string: "https://api.platerecognizer.com/")
        case .carsXe:
            return URL(string: "https://api.carsxe.com/")
        }
    }
}

public enum HTTPMethod: String {
    case get   = "GET"
    case put   = "PUT"
    case post  = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Configures parameters for a specific endpoing
public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParams: Parameters?, urlParams: Parameters?, additionalHeaders: HTTPHeaders?)
}
