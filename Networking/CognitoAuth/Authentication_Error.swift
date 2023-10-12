//
//  Authentication_Error.swift
//  Motorvate
//
//  Created by Emmanuel on 9/22/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

enum AuthenticationError: Error {
    case creationError(String)
    case signOutFailed(String)
    case signInFailed(String)
    case userNotConfirmed
    case passwordCodeRequestfailed
}
