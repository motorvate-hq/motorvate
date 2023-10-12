//
//  CreateInquiryRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 30.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

struct CreateInquiryRequest: Codable {
    let carModel: String?
    let customerEmail: String?
    let customerFirstName: String?
    let customerLastName: String?
    let customerPhone: String?
    let service: String?
    let shopID: String?
}
