//
//  UpdateReadStatusRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 09.06.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

struct UpdateReadStatusRequest: Encodable {
    let shopID: String
    let customerID: String
}
