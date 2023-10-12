//
//  AddUpdateInquiryRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

struct AddUpdateInquiryRequest: Codable {
    let inquiryID: String?
    let inquiryDetail: InquiryDetail
}
