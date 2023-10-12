//
//  CreateJobRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 02.05.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

struct CreateJobRequest: Encodable {
    var shopID: String?
    let customerFirstName: String?
    var inquiryID: String?
    let carModel: String?
    var userID: String?
    let jobType: String?
    let service: String?
    let customerPhone: String?
    let customerEmail: String?
    var vin: String?
    let quote: Double?
    let customerLastName: String?
    let note: String?
}
