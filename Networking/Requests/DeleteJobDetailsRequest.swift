//
//  DeleteJobDetailsRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 31.05.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

struct DeleteJobDetailsRequest: Encodable {
    let jobID: String
    let detailID: String
}
