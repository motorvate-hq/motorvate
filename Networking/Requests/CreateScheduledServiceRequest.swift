//
//  CreateScheduledServiceRequest.swift
//  Motorvate
//
//  Created by Motorvate on 8.4.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import Foundation

struct CreateScheduledServiceRequest: Encodable {
    var shopId: String
    var scheduledData: [ScheduledData]
    var shopSize: Int?
}
