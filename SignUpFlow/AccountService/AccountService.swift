//
//  AccountService.swift
//  Motorvate
//
//  Created by Emmanuel on 1/24/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

final class AccountService {
    private (set) var authorizer: Authenticator

    init(with authorizer: Authenticator = Authenticator.default) {
        self.authorizer = authorizer
    }
}
