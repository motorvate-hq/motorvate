//
//  ChatAttachmentsViewModel.swift
//  Motorvate
//
//  Created by Nikita Benin on 23.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

enum ChatAttachmentsViewModel: CaseIterable {
    static var allCases: [ChatAttachmentsViewModel] {
        return [.invoice, .serviceItem, .depositEstimate(excludingDeposit: false), .depositEstimate(excludingDeposit: true), .onboardVehicle]
    }
//    case image
//    case delete
    case invoice
    case serviceItem
    case depositEstimate(excludingDeposit: Bool)
    case onboardVehicle
    
    var cellType: ChatAttachmentsCellType {
        switch self {
//        case .image, .delete:
//            return ChatAttachmentsCellType.icon
        case .invoice, .serviceItem, .depositEstimate(_), .onboardVehicle:
            return .text
        }
    }
    
    var title: String? {
        switch self {
        case .invoice:          return "Payment + Invoice"
        case .serviceItem:      return "Add/Modify Service Item"
        case .depositEstimate(let excludingDeposit):  return excludingDeposit ? "Create Estimate" : "Deposit + Estimate"
        case .onboardVehicle:   return "Onboard Vehicle"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .depositEstimate(let excludingDeposit):
            return excludingDeposit ? R.image.createEstimate() : R.image.chatPayment()
        case .invoice:
            return R.image.chatPayment()
        case .serviceItem:
            return R.image.yellowInfo()
        case .onboardVehicle:
            return R.image.onboardVehicle()
        }
    }
    
    var iconSize: CGFloat? {
        switch self {
        case .invoice:          return 44
        case .serviceItem:      return 21
        case .depositEstimate(let excludingDeposit):  return excludingDeposit ? 34 : 44
        case .onboardVehicle:   return 34
        }
    }
    
    var cellWidth: CGFloat {
        switch self {
        case .invoice:          return 210
        case .serviceItem:      return 226
        case .depositEstimate(let excludingDeposit):  return excludingDeposit ? 180 : 210
        case .onboardVehicle:   return 180
        }
    }
}
