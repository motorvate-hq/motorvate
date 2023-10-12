//
//  APNsNotificationType.swift
//  Motorvate
//
//  Created by Nikita Benin on 28.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

public enum APNsNotificationType {
    case newMessage(customerId: String?)
    case newInquiry
    case newDepositEstimateConfirm
    case depositPaid
    
    var pushType: String {
        switch self {
        case .newMessage:                   return "newMessage"
        case .newInquiry:                   return "newInquiry"
        case .newDepositEstimateConfirm:    return "newDepositEstimateConfirm"
        case .depositPaid:                  return "depositPaid"
        }
    }
}
