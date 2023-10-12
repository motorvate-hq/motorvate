//
//  JSONParameterEncoder.swift
//  Motorvate
//
//  Created by Emmanuel on 6/8/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    private enum Constants {
        static let ContentTypeKey = "Content-Type"
        static let ApplicationJsonKey = "application/json"
    }
    
    public static func encode(urlRquest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRquest.httpBody = jsonData
            if urlRquest.value(forHTTPHeaderField: Constants.ContentTypeKey) == nil {
                urlRquest.setValue(Constants.ApplicationJsonKey, forHTTPHeaderField: Constants.ContentTypeKey)
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
