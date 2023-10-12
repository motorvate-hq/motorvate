//
//  SendFormLinkRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

struct SendFormLinkRequest: Encodable {
    let shopID: String
    let customerPhone: String
    let isScheduleToken: Bool
}
