//
//  NotificationCenterActionModel.swift
//  Motorvate
//
//  Created by Nikita Benin on 17.02.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

enum NotificationCenterActionModel: Int, CaseIterable {
    case viewNumber
    case viewTransactions
    case automateInquiries
    case seeHowOnboard
    case connectbank
    case partnerAffirm
    case learnEstimates
    case contactSupport
    
    var titleText: String {
        switch self {
        case .viewNumber:
            return "View My Number"
        case .viewTransactions:
            return "View Transactions / Balance"
        case .automateInquiries:
            return "Watch how we automate customer\nInquries with your new shop number  🎥"
        case .seeHowOnboard:
            return "See how we onboard customer vehicles instantly without paper 🚗 👀"
        case .connectbank:
            return "Learn how to Connect Bank / Debit card to\nreceive instant payments on your invoices 💰"
        case .partnerAffirm:
            return "We partnered with Affirm so you can offer financing to your customers today (Tap to learn more)"
        case .learnEstimates:
            return "Learn how to create Estimates and collect Deposits from any Inquiry 💰📖"
        case .contactSupport:
            return "Call / Text Support"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .viewNumber:
            return R.image.notificationMessage()
        case .viewTransactions:
            return R.image.notificationCard()
        case .automateInquiries, .seeHowOnboard, .connectbank, .partnerAffirm, .learnEstimates:
            return nil
        case .contactSupport:
            return R.image.notificationWhatsApp()
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .viewNumber, .viewTransactions, .automateInquiries, .seeHowOnboard, .connectbank, .partnerAffirm, .learnEstimates:
            return .white
        case .contactSupport:
            return .black
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .viewNumber:
            return UIColor(red: 1, green: 0.682, blue: 0.075, alpha: 0.85)
        case .viewTransactions:
            return UIColor(red: 0.106, green: 0.204, blue: 0.808, alpha: 0.85)
        case .automateInquiries:
            return UIColor(red: 0.357, green: 0.569, blue: 0.016, alpha: 0.85)
        case .seeHowOnboard:
            return UIColor(red: 1, green: 0.682, blue: 0.075, alpha: 0.85)
        case .connectbank:
            return UIColor(red: 0.106, green: 0.204, blue: 0.808, alpha: 0.85)
        case .partnerAffirm:
            return UIColor(red: 0.38, green: 0.235, blue: 0.733, alpha: 0.85)
        case .learnEstimates:
            return UIColor(red: 0.357, green: 0.569, blue: 0.016, alpha: 0.85)
        case .contactSupport:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 0.85)
        }
    }
}
