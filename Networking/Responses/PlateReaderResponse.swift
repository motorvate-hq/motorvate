//
//  PlateReaderResponse.swift
//  Motorvate
//
//  Created by Nikita Benin on 19.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

struct PlateReaderResult: Decodable {
    let plate: String
    let region: PlateReaderRegion
}

struct PlateReaderRegion: Decodable {
    let code: String
}

struct PlateReaderResponse: Decodable {
    let results: [PlateReaderResult]
}

extension PlateReaderResponse {
    var licensePlate: String {
        if let result = results.first,
           let state = result.region.code.split(separator: "-").last {
            return "\(state) \(result.plate)".uppercased()
        }
        return ""
    }
}
