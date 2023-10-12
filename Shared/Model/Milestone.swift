//
//  JobMilestone.swift
//  Motorvate
//
//  Created by Emmanuel on 3/4/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

struct Milestone: Decodable {
//    var inProgress: InProgress?
//    var dropOffStatus: Dropoff?
//    var onboardStatus: Onboard?
    var complete: Complete?
}

extension Milestone {
    struct InProgress: Decodable {
        let timestamp: String
    }

    struct Dropoff: Decodable {
        let timestamp: String
        let ownerID: String
        let dropoffDate: Drop
    }

    struct Drop: Decodable {
        let date: String
        let slot: String
    }

    struct Onboard: Decodable {
        let timestamp: String
        let ownerID: String
        let completionEstimate: String
    }

    struct Complete: Decodable {
        let timestamp: String
        let ownerID: String

        var date: Date? {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            return dateFormatter.date(from: timestamp)
        }
    }
}
