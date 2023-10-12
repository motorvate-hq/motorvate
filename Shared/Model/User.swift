//
//  User.swift
//  Motorvate
//
//  Created by Emmanuel on 9/6/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import MessageKit

public struct User: Decodable {
    let userID: String
    let shopID: String?
    let email: String
    let firstName: String?
    let lastName: String?
    let pnToken: String?
    let snsEndpoint: String?

    init(userID: String,
         firstName: String,
         lastName: String,
         shopID: String = "",
         pnToken: String = "",
         snsEndpoint: String = "",
         email: String = "") {

        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.shopID = shopID
        self.pnToken = pnToken
        self.snsEndpoint = snsEndpoint
        self.email = email
    }
}

// MARK: - MessageKit SenderType
extension User: SenderType {
    public var senderId: String {
//        return "user"
        return userID
    }

    public var displayName: String {
        return (firstName ?? "") + (lastName ?? "")
    }
}
