//
//  AddUpdateJobDetailsRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 31.05.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

struct AddUpdateJobDetailsRequest: Encodable {
    let jobID: String
    let jobDetail: ServiceDetail
}
