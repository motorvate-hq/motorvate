//
//  UIColor+Extensions.swift
//  Motorvate
//
//  Created by Emmanuel on 5/1/18.
//  Copyright © 2018 motorvate. All rights reserved.
//

import SwiftUI

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}

extension UIColor {
    var color: Color {
        Color(self)
    }
}
