//
//  NotificationCenterVM.swift
//  Motorvate
//
//  Created by Nikita Benin on 17.02.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

class NotificationCenterVM {
    let actionModels: [NotificationCenterActionModel] = NotificationCenterActionModel.allCases
    let featureNotifications: [FeatureNotificationModel] = [
        .init(
            title: "Version 2.2.25",
            text: "• Updated Start OnBoard view to make pass service information easier from Inquiries\n• Added “Start OnBoard” to Chat for quicker access\n• Added “View Invoice” to Customers for completed jobs\n• Added option to Delete Inquirires\n• We added your business address to your web customer forms (Inquries & Estimates)"
        ),
        .init(
            title: "Version 2.2.24",
            text: "We updated Payment Confirmation to Notification Center so you View Transactions / Balance and invoice history.\n\nThis includes updates to:\n• Settings\n• Payment Confirmation\n• Ability to pass the service fee to customers\n• Save Inquiries Manually\n• And Onboarding Tutorials"
        )
    ]
    
    func notificationCounterForModel(_ model: NotificationCenterActionModel) -> Int {
        switch model {
        case .viewNumber:
            return UserSettings().didShowInquiryFormsPopup ? 0 : 1
        case .viewTransactions:
            return UserSettings().depositPaidNotificationsCounter
        case .automateInquiries:
            return UserSettings().hasSeenAutomateInquiriesVideo ? 0 : 1
        case .seeHowOnboard:
            return UserSettings().hasSeenHowOnboardVideo ? 0 : 1
        case .connectbank:
            return UserSettings().hasSeenConnectBank ? 0 : 1
        case .partnerAffirm:
            return UserSettings().hasSeenPartnerAffirm ? 0 : 1
        case .learnEstimates:
            return UserSettings().hasSeenEstimateWalkthroughFlow ? 0 : 1
        case .contactSupport:
            return 0
        }
    }
    
    func numberOfSections() -> Int {
        return NotificationCenterSectionType.allCases.count
    }
    
    func numberOfItems(section: Int) -> Int {
        guard let type = NotificationCenterSectionType(rawValue: section) else { return 0 }
        switch type {
        case .actions:  return actionModels.count
        case .features: return featureNotifications.count
        default: return 0
        }
    }
    
    func titleForSection(section: Int) -> String {
        return NotificationCenterSectionType(rawValue: section)?.title ?? ""
    }
}
