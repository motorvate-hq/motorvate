//
//  AnalyticsManager.swift
//  Motorvate
//
//  Created by Nikita Benin on 02.08.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import FirebaseAnalytics

class AnalyticsManager {
    
    static func logEvent(_ type: AnalyticsEventsTypes) {
        print("AnalyticsManager - logged event:", type.eventName, ", parameters:", type.parameters as Any)
        Analytics.logEvent(type.eventName, parameters: type.parameters)
    }
    
    static func logJobStatusChange(_ status: Job.Status) {
        switch status {
        case .inqueue:      AnalyticsManager.logEvent(.jobStatusInQueue)
        case .inProgress:   AnalyticsManager.logEvent(.jobStatusInProgress)
        case .completed:    AnalyticsManager.logEvent(.jobStatusCompleted)
        case .none:         break
        }
    }
}
