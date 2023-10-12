//
//  ChatHistory.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-04-19.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

struct ChatHistory: Decodable {
    
    let shopID: String
    let shopPhone: String
    let topicArn: String
    let createDate: String
    let unreadQuantity: Int?
    let chat: [ChatMessage]
    
    let inquiries: [Inquiry]?
    let customer: Customer
    var jobs: [Job]?
}
