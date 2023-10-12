//
//  GetFormInfoRequest.swift
//  Motorvate
//
//  Created by Bojan on 25.03.2023.
//  Copyright © 2023 motorvate. All rights reserved.
//

import Foundation

struct GetFormInfoRequest: Encodable {
    let shopID: String
    let customerPhone: String
    let isScheduleToken: Bool
}
