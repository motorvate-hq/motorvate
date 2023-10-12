//
//  Authenticator_AuthState.swift
//  Motorvate
//
//  Created by Emmanuel on 9/22/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

// MARK: - AuthState

enum AuthState {
    case signedIn
    case signedOut
    case unconfirmed
    case confirmed
    case newPassword(challengeResponse: String)
    case shopIdentifierRequired
}

// MARK: Equatable
extension AuthState: Equatable {
    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.signedIn, .signedIn):
            return true

        case (.signedOut, .signedOut):
            return true

        case (.unconfirmed, .unconfirmed):
            return true

        case (.confirmed, .confirmed):
            return true

        case (.newPassword(let lhsResponse), .newPassword(let rhsResponse) ):
            return lhsResponse == rhsResponse

        default:
            return false
        }
    }
}

// MARK: - PasswordRequestState
enum PasswordRequestState {
    case confirmed
    case sent(String)
    case none
}

extension PasswordRequestState {
    var resultValue: String {
        switch self {
        case .sent(let value):
            return value
        case .confirmed:
            return "Confirmed"
        case .none:
            return "failed"
        }
    }
}
