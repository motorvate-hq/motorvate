//
//  ChatMessage.swift
//  Motorvate
//
//  Created by Nikita Benin on 29.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

struct ChatMessage: Codable {
    let source: String
    let text: String
    let createDate: String
    let updateDate: String?
    let status: String?
    let sid: String
}
