//
//  ScanError.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

enum ScanError {
    case undableToScan
    case noVinForScan(plate: String)
    
    var errorText: String {
        switch self {
        case .undableToScan:    return "Unable to recognize license plate."
        case .noVinForScan(let plate):     return "Unable to find VIN for a license plate: \(plate)"
        }
    }
}
