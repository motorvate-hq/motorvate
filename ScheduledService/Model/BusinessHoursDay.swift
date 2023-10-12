//
//  BusinessHoursDay.swift
//  Motorvate
//
//  Created by Motorvate on 7.3.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import Foundation

struct BusinessHoursDay {
    var day: String
    var isOpen: Bool
    var openTime: String?
    var closeTime: String?
    
    var formatted: String {
        if !isOpen {
            return "Closed"
        }
        
        return (openTime ?? "") + " - " + (closeTime ?? "")
    }
}

extension BusinessHoursDay: Equatable {
    
}
