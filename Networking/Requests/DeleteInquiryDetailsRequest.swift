//
//  DeleteInquiryDetailsRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 17.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

struct DeleteInquiryDetailsRequest: Encodable {
    let inquiryID: String
    let detailID: String
}
