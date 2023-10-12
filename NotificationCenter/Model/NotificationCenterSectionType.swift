//
//  NotificationCenterSectionType.swift
//  Motorvate
//
//  Created by Nikita Benin on 04.05.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

enum NotificationCenterSectionType: Int, CaseIterable {
    case actions
    case features
    
    var title: String {
        switch self {
        case .actions:  return "Hey \(UserSession.shared.shop?.businessName ?? "")  🚗💨"
        case .features: return "What’s new?"
        }
    }
}
