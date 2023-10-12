//
//  AccountSettingItem.swift
//  Motorvate
//
//  Created by Nikita Benin on 06.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

enum AccountSettingItem: Int {
    case changeEmail
    case deleteAccount
    case connectToAccounts
    case changePassword
    case development
}

extension AccountSettingItem {
    var stringValue: String {
        switch self {
        case .changeEmail:          return "Change Email"
        case .connectToAccounts:    return "Connect to accounts"
        case .changePassword:       return "Change Password"
        case .development:          return "Development"
        case .deleteAccount:        return "Delete Account"
        }
    }
}
