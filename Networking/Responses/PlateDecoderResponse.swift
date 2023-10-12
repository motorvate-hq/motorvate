//
//  PlateDecoderResponse.swift
//  Motorvate
//
//  Created by Nikita Benin on 19.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

struct PlateDecoderLicensePlate: Decodable {
    let plate: String
    let state: String
}

struct PlateDecoderResponse: Decodable {
    let input: PlateDecoderLicensePlate
    let vin: String
}

extension PlateDecoderResponse {
    var licensePlateString: String {
        return "\(input.state)\n\(input.plate.uppercased())"
    }
}
