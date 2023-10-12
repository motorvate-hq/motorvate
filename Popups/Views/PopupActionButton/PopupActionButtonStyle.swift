//
//  PopupActionButtonStyle.swift
//  Motorvate
//
//  Created by Nikita Benin on 24.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

enum PopupActionButtonStyle {
    case blue
    case green
    case yellow
    case purple
    case gray
    
    var textColor: UIColor {
        switch self {
        case .blue, .green, .purple, .gray:
            return .white
        case .yellow:
            return .black
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .blue:     return UIColor(red: 0.105, green: 0.206, blue: 0.807, alpha: 1)
        case .green:    return UIColor(red: 0.36, green: 0.57, blue: 0.02, alpha: 1)
        case .yellow:   return UIColor(red: 1, green: 0.682, blue: 0.075, alpha: 1)
        case .purple:   return UIColor(red: 0.38, green: 0.235, blue: 0.733, alpha: 1)
        case .gray:     return UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
        }
    }
}
