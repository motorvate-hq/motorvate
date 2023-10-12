//
//  Inquiry.swift
//  Motorvate
//
//  Created by Emmanuel on 5/2/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

final class Inquiry: Decodable {
    // swiftlint:disable identifier_name
    var id: String = ""
    var createdAt: Date?
    
    var userID: String?
    var shopID: String?
    var model: String = ""
    var service: String = ""
    var note: String = ""
    var status: Status = .open
    var customer: Customer?
    var inquiryDetails: [ServiceDetail]?
}

extension Inquiry {
    enum Status: String, Codable {
        case open
        case closed
    }
}

extension Inquiry {
    enum Keys: String, CodingKey {
        // swiftlint:disable identifier_name
        case id
        case createdAt
        case userID
        case shopID
        case model = "carModel"
        case service
        case note
        case customerID
        case email = "customerEmail"
        case firstName = "customerFirstName"
        case lastName = "customerLastName"
        case status
        case phone = "customerPhone"
        case inquiryDetails
    }
    
    convenience init(
        id: String,
        createdAt: Date?,
        userID: String?,
        shopID: String?,
        model: String,
        service: String,
        note: String,
        status: Status,
        customer: Customer?
    ) {
        self.init()
        
        self.id = id
        self.createdAt = createdAt
        self.userID = userID
        self.shopID = shopID
        self.model = model
        self.service = service
        self.note = note
        self.status = status
        self.customer = customer
    }

    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(String.self, forKey: .id)
        createdAt =
            try? DateFormatter().decodeServerDate(from: container.decode(String.self, forKey: .createdAt))
        userID = try container.decodeIfPresent(String.self, forKey: .userID)
        shopID = try container.decodeIfPresent(String.self, forKey: .shopID)
        model = try container.decode(String.self, forKey: .model)
        service = try container.decode(String.self, forKey: .service)
        note = try container.decodeIfPresent(String.self, forKey: .note) ?? ""
        status = try container.decode(Status.self, forKey: .status)
        inquiryDetails = try container.decodeIfPresent([ServiceDetail].self, forKey: .inquiryDetails)

        // This should not be nil. Since it not being returned from the API and we have added a fix. ONce its merged we will remove this and make it non optional
        let identifier = try container.decodeIfPresent(String.self, forKey: .customerID) ?? ""
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        let phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        let email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        customer = Customer(customerID: identifier, firstName: firstName, lastName: lastName, phoneNumber: phone, email: email)
      }
}

// MARK: - Hashable
extension Inquiry: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Inquiry, rhs: Inquiry) -> Bool {
        lhs.id == rhs.id
    }
}
