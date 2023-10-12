//
//  APNsNotification.swift
//  Motorvate
//
//  Created by Nikita Benin on 28.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

public struct APNsNotification {
    
    let title: String?
    let body: String?
    let type: APNsNotificationType?
    
    init?(userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let payload = userInfo["payload"] as? [String: Any] {
            
            self.title = alert["title"] as? String
            self.body = alert["body"] as? String
            self.type = {
                guard let type = payload["type"] as? String else { return nil }
                switch type {
                case APNsNotificationType.newMessage(customerId: payload["customerID"] as? String).pushType:
                    return APNsNotificationType.newMessage(customerId: payload["customerID"] as? String)
                case APNsNotificationType.newInquiry.pushType:
                    return APNsNotificationType.newInquiry
                case APNsNotificationType.newDepositEstimateConfirm.pushType:
                    return APNsNotificationType.newDepositEstimateConfirm
                case APNsNotificationType.depositPaid.pushType:
                    return APNsNotificationType.depositPaid
                default:
                    return nil
                }
            }()
            
        } else {
            return nil
        }
    }
}
