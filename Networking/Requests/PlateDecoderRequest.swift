//
//  PlateDecoderRequest.swift
//  Motorvate
//
//  Created by Nikita Benin on 19.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

struct PlateDecoderRequest: Encodable {
    let key: String = Environment.carsXeAuthToken
    let plate: String
    let state: String
    let format: String = "json"
    
    init(plateReaderResponse: PlateReaderResponse) {
        if let firstPlate = plateReaderResponse.results.first {
            self.plate = firstPlate.plate
            self.state = firstPlate.region.code.components(separatedBy: "-").last ?? ""
        } else {
            self.plate = ""
            self.state = ""
        }
    }
}
