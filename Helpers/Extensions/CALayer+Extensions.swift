//
//  CALayer+Extensions.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

extension CALayer {
    func addShadow(backgroundColor: UIColor, shadowColor: UIColor, cornerRadius: CGFloat, shadowRadius: CGFloat, shadowOffset: CGSize = .zero) {
        self.backgroundColor = backgroundColor.cgColor
        self.shadowColor = shadowColor.cgColor
        self.shadowOpacity = 1
        self.shadowOffset = shadowOffset
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
}
