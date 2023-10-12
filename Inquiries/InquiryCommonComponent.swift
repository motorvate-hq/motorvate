//
//  InquiryCommonComponent.swift
//  Motorvate
//
//  Created by Emmanuel on 2/24/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

struct InquiryCommonComponent {
    fileprivate enum Constant {
        static let headerFontSize: CGFloat = 15.7
        static let headerTextColor: UIColor = .black
    }

    static func setupTitleLabel(with title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.semiBold, ofSize: 14.3)
        label.text = title
        label.textColor = .black
        return label
    }

    static func setupHeaderLabel(with title: String) -> UILabel {
        let headerlabel = UILabel()
        headerlabel.translatesAutoresizingMaskIntoConstraints = false
        headerlabel.font = AppFont.archivo(.bold, ofSize: Constant.headerFontSize)
        headerlabel.textColor = Constant.headerTextColor
        headerlabel.text = title
        headerlabel.numberOfLines = 2
        return headerlabel
    }
}
