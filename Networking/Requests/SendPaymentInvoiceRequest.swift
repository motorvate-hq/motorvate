//
//  SendPaymentInvoiceRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 31.05.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

struct SendPaymentInvoiceRequest: Encodable {
    let shopID: String
    let customerPhone: String
    let jobID: String
    let customerID: String
    let topicArn: String
    let feeFromShop: Int
    
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
