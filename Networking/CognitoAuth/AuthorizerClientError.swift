//
//  AuthorizerClientError.swift
//  Motorvate
//
//  Created by Emmanuel on 3/3/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import AWSMobileClientXCF

struct AuthorizerClientError {
    static func message(from error: Error?) -> String {
        let message = "Something went wrong while creating the account. Please try logging in if you have an account."
        guard let error = error else { return message }
        guard let clientError = error as? AWSMobileClientError else { return message }
        return clientError.message
    }
}

extension AWSMobileClientError {
    var message: String {
        switch self {
        case .aliasExists(let message):
            return message
        case .invalidParameter(let message):
            return message
        case .invalidPassword(let message):
            return message
        case .usernameExists(let message):
            return message
        default: return "Something went wrong while creating the account. Please try logging in if you have an account."
        }
    }
}
