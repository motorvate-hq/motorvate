//
//  URLParameterEncoder.swift
//  Motorvate
//
//  Created by Emmanuel on 6/8/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    
    private enum Constants {
        static let HTTPHeaderContentType = "Content-Type"
        static let HTTPURLEncodingType = "application/x-www-form-urlencoded; charset=utf-8"
    }
    
    public static func encode(urlRquest: inout URLRequest, with parameters: Parameters) throws {
        
        guard let url = urlRquest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRquest.url = urlComponents.url
        }
        
        if urlRquest.value(forHTTPHeaderField: Constants.HTTPHeaderContentType) == nil {
            urlRquest.setValue(Constants.HTTPURLEncodingType, forHTTPHeaderField: Constants.HTTPHeaderContentType)
        }
    }
}
