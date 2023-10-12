//
//  Shop.swift
//  Motorvate
//
//  Created by Emmanuel on 2/13/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

struct Shop: Decodable {
    let id: Identifier
    let owner: String
    let businessName: String
    let topicArn: String
    let shopTelephone: String?
    let serviceTypes: [String]?
    let businessProfiles: [BusinessProfile]?
    let payments: [String]?
    let invoicing: [String]?
    let marketing: [String]?
    let scheduledData: [ScheduledData]?
    let shopSize: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "shopID"
        case owner
        case businessName
        case topicArn
        case shopTelephone
        case serviceTypes
        case businessProfiles
        case payments
        case invoicing
        case marketing
        case scheduledData
        case shopSize
    }
}

struct BusinessProfile: Decodable {
    let key: String?
    let profileName: String?
}

// MARK: - Identifiable & Hashable
extension Shop: Identifiable {
    public typealias Identifier = String
}

extension Shop: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Shop, rhs: Shop) -> Bool {
        lhs.id == rhs.id
    }
}
