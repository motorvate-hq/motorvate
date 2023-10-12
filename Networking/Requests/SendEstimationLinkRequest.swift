//
//  SendEstimationLinkRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 18.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

struct SendEstimationLinkRequest: Encodable {
    let inquiryID: String
    let depositPercent: Int
    let isPreview: Int = 0
    let feeFromShop: Int
    
    init(inquiryID: String, depositPercent: Int, feeFromShop: Bool) {
        self.inquiryID = inquiryID
        self.depositPercent = depositPercent
        self.feeFromShop = feeFromShop ? 1 : 0
    }
}
