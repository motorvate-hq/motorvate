//
//  CreateStripeAccountLinkResponse.swift
//  Motorvate
//
//  Created by Nikita Benin on 12.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

struct CreateStripeAccountLinkResponse: Decodable {
    let object: String
    let created: Int
    let expires_at: Int
    let url: String
}
