//
//  AuthenticationConfiguration.swift
//  Motorvate
//
//  Created by Emmanuel on 10/17/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

struct AuthenticationConfiguration {
    private enum _Keys {
        static let poolID = "COGNITO_APP_POOL_ID"
        static let appClientID = "COGNITO_APP_POOL_CLIENT"
        static let identityPoolId = "COGNITO_IDENTITY_POOL_ID"
    }

    static func loadConfiguration() -> [String: Any] {
        return [
            "IdentityManager": [
                "Default": [:]
            ],
            "CredentialsProvider": [
                "CognitoIdentity": [
                    "Default": [
                        "PoolId": "\(Environment.congitoConfig(for: _Keys.identityPoolId))",
                        "Region": "us-east-1"
                    ]
                ]
            ],
            "CognitoUserPool": [
                "Default": [
                    "PoolId": "\(Environment.congitoConfig(for: _Keys.poolID))",
                    "AppClientId": "\(Environment.congitoConfig(for: _Keys.appClientID))",
                    "Region": "us-east-1"
                ]
            ]
        ]
    }
}
