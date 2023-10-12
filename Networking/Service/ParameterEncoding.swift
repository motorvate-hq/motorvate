//
//  ParameterEncoding.swift
//  Motorvate
//
//  Created by Emmanuel on 6/8/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    static func encode(urlRquest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Failed to encode Params"
    case missingURL = "URL is nil "
}
