//
//  DepositEstimateType.swift
//  Motorvate
//
//  Created by Nikita Benin on 17.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

enum DepositEstimateType {
    case percent25
    case percent50
    case percent100
    case none
    
    var percent: Double {
        switch self {
        case .percent25:    return 25
        case .percent50:    return 50
        case .percent100:    return 100
        case .none: return -1
        }
    }
}
