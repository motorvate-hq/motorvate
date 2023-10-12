//
//  ServiceType.swift
//  Motorvate
//
//  Created by Nikita Benin on 25.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

enum ServiceType {
    case job
    case inquiry(excludingDeposit: Bool)
    
    var isExcludingDeposit: Bool {
        switch self {
        case .job: return false
        case .inquiry(let excludingDeposit): return excludingDeposit
        }
    }
}
