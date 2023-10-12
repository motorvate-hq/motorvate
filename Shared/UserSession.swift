//
//  UserSession.swift
//  Motorvate
//
//  Created by Emmanuel on 2/22/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

class UserSession {
    static let shared = UserSession()

    private init() {}

    var user: User? {
        return UDRepository.shared.getItem(User.self, for: UserService.Constants.encodedUserKey)
    }

    var shop: Shop? {
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
        return UDRepository.shared.getItem(Shop.self, for: UserService.Constants.encodedShopKey)
    }

    var isLoggedIn: Bool {
        Authenticator.default.isSignedIn
    }

    var userID: String? {
        return  Authenticator.default.userID
    }

    var shopID: String? {
        return user?.shopID
    }

    var shopName: String {
        shop?.businessName ?? "Motorvate"
    }

    func getRequiredUserParamsForRequest() -> Parameters? {
        guard let shopID = shopID else { return nil }
        guard let userID = userID else { return nil }

        let params: Parameters = [
            "shopID": shopID,
            "userID": userID
        ]

        return params
    }
}

extension Notification.Name {
    static let DidLogOutSuccessfully = Notification.Name("didLogOutSuccessfully")
    static let ForceLogoutAuthorizationTokenUnavailable = Notification.Name("forceLogoutAuthorizationTokenUnavailable")
}
