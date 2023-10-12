//
//  PaymentInvoicePreviewLinkRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 28.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

struct PaymentInvoicePreviewLinkRequest: Encodable {
    let shopID: String
    let customerPhone: String
    let jobID: String
    let customerID: String
    let topicArn: String
    let feeFromShop: Int
    let isPreview: Int = 1
    
    init(
        shopID: String,
        customerPhone: String,
        jobID: String,
        customerID: String,
        topicArn: String,
        feeFromShop: Bool
    ) {
        self.shopID = shopID
        self.customerPhone = customerPhone
        self.jobID = jobID
        self.customerID = customerID
        self.topicArn = topicArn
        self.feeFromShop = feeFromShop ? 1 : 0
    }
}
