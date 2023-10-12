//
//  Constraint+Extensions.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-12.
//  Copyright © 2019 motorvate. All rights reserved.
//

import SnapKit
import UIKit

extension UIView {
    func fillSuperView(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            fatalError("Be sure that the view has a superview!")
        }
        superview.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: insets.left),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: -insets.right),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: -insets.bottom),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: insets.top)
            ])
    }

    func constraintSize(_ size: CGSize) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: size.width),
            self.heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
}

extension UIView {
    var safeArea: ConstraintLayoutGuideDSL {
        return safeAreaLayoutGuide.snp
    }
}
