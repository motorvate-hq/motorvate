//
//  InviteMemberErrorResponse.swift
//  Motorvate
//
//  Created by Nikita Benin on 04.08.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

struct InviteMemberErrorResponse: Codable {
    let message: String
    
    init(data: Data) {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(InviteMemberErrorResponse.self, from: data) {
            self.message = decoded.message
        } else {
            self.message = "Unable to send invite"
        }
    }
}
