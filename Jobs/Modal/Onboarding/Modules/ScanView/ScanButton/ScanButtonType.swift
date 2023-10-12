//
//  ScanButtonType.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

enum ScanButtonType: CaseIterable {
    case licensePlate
    case vin
    
    var title: String {
        switch self {
        case .licensePlate: return "Scan License Plate"
        case .vin:          return "Scan VIN"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .licensePlate: return R.image.scanLicensePlate()
        case .vin:          return R.image.barcode()
        }
    }
}
