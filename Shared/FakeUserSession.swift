//
//  FakeUserSession.swift
//  Motorvate
//
//  Created by Emmanuel on 11/15/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

class FakeUserSession {
    static let shared = FakeUserSession()

    private init () {}

    var user: User {
        return User(userID: "D982FB49-1452-4BA4-8A45-0FDC8E421887", firstName: "sean", lastName: "Pana")
    }

    var botUser: User {
        return User(userID: "D982FB45-1452-4BA4-8A45-0FDC8E421823", firstName: "bot", lastName: "user")
    }

    func isCurrentUser(_ userId: String) -> Bool {
        return userId == user.userID
    }
}
