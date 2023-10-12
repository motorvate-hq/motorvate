//
//  SettingItem.swift
//  Motorvate
//
//  Created by Nikita Benin on 06.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

// MARK: - SettingItem
enum SettingItem {
    case automatedMessage
    case businessInformation
    case account
    case contentLibrary
    case logout
    case addTeamMembers
    case shopNameAndPhone
    case connectBank
    case updateBank
}

extension SettingItem {
    var stringValue: String {
        switch self {
        case .automatedMessage:
            return "Automated Messaging Presets"
        case .businessInformation:
            return "Business Information"
        case .account:
            return "Account"
        case .contentLibrary:
            return "Content Library"
        case .logout:
            return "Log Out"
        case .addTeamMembers:
            return "Add Team Members"
        case .shopNameAndPhone:
            guard let shop = UserSession.shared.shop else { return "No name" }
            return shop.businessName
        case .connectBank:
            return "Connect bank"
        case .updateBank:
            return "Update bank / Debit Card"
        }
    }

    var imageName: String {
        switch self {
        case .automatedMessage:         return "presets"
        case .businessInformation:      return "business-info"
        case .account:                  return "account"
        case .contentLibrary:           return "content-library"
        case .logout:                   return "logout"
        case .addTeamMembers:           return "settingsAddTeamMembers"
        case .shopNameAndPhone:         return "home"
        case .connectBank, .updateBank: return "settingsConnectBank"
        }
    }
    
    var imageSize: CGSize {
        switch self {
        case .connectBank, .updateBank:
            return CGSize(width: 32, height: 30)
        case .addTeamMembers:
            return CGSize(width: 52, height: 34)
        default:
            return CGSize(width: 20, height: 23)
        }
    }
    
    var imageViewLeadingOffset: CGFloat {
        switch self {
        case .connectBank, .updateBank:
            return 32
        case .addTeamMembers:
            return 22
        default:
            return 38
        }
    }
}
