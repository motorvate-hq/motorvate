//
//  NSMutableAttributedString+Extensions.swift
//  Motorvate
//
//  Created by Nikita Benin on 18.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    func setFontForText(textForAttribute: String, withFont font: UIFont) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}
