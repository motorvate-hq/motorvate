//
//  UIView+Extensions.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, cornerRadii: CGSize) {
       let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: cornerRadii)
       let maskLayer1 = CAShapeLayer()
       maskLayer1.frame = self.bounds
       maskLayer1.path = maskPAth1.cgPath
       self.layer.mask = maskLayer1
   }
}

extension UIView {
    class func fromNib<T: UIView>() -> T? {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as? T
    }
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}

extension UIView {
    var globalFrame: CGRect? {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let rootView = keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}
