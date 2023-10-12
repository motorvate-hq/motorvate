//
//  ServiceDetail.swift
//  Motorvate
//
//  Created by Nikita Benin on 31.05.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

struct ServiceDetail: Codable {
    let id: String?
    var description: String?
    var price: Double?
}

extension ServiceDetail {
    static func mockObject() -> ServiceDetail {
        return ServiceDetail(
            id: "\(Int.random(in: 0...10))",
            description: "some description",
            price: Double.random(in: 10...500)
        )
    }
}
