//
//  Customer.swift
//  Motorvate
//
//  Created by Emmanuel on 3/4/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

public struct Customer: Decodable {
    public let customerID: String?
    public let firstName: String?
    public let lastName: String?
    public let phoneNumber: String?
    public let email: String?

    var fullName: String? {
        if let firstName = firstName, let lastName = lastName {
            return "\(firstName) \(lastName)"
        }
        return nil
    }
}
