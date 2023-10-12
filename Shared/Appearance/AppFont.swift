//
//  AppFont.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-12.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

struct AppFont {
    enum FontStyle: String, RawRepresentable {
        case bold = "Archivo-Bold"
        case boldItalic = "Archivo-BoldItalic"
        case italic = "Archivo-Italic"
        case medium = "Archivo-Medium"
        case mediumItalic = "Archivo-MediumItalic"
        case regular = "Archivo-Regular"
        case semiBold = "Archivo-SemiBold"
        case semiBoldItalic = "Archivo-SemiBoldItalic"
    }

    static func archivo(_ style: FontStyle = .regular, ofSize: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: style.rawValue, size: ofSize) else {
            return UIFont.systemFont(ofSize: ofSize)
        }
        return customFont
    }
    
    static func poppinsRegular(ofSize: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Poppins-Regular", size: ofSize) else {
            return UIFont.systemFont(ofSize: ofSize)
        }
        return customFont
    }
}
