//
//  AuthorizerCredentials.swift
//  Motorvate
//
//  Created by Emmanuel on 3/2/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

extension Authenticator {
    struct Credentials {
        let email: String
        let password: String
        let phoneNumber: String

        init(_ email: String, _ password: String, _ phone: String? = nil) {
            self.email = email
            self.password = password
            self.phoneNumber = phone ?? ""
        }

        var username: String {
            return email
        }

        var userAttributes: [String: String] {
            return ["phone_number": phoneNumber]
        }
    }
}
