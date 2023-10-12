//
//  JobFooterCollectionViewCell.swift
//  Motorvate
//
//  Created by Emmanuel on 8/2/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class JobFooterReusableView: UICollectionReusableView {

    private enum Constants {
        static let leadingConstant: CGFloat = 20.0
        static let trailingConstant: CGFloat = -20.0
        static let height: CGFloat = 1
    }

    lazy var dividerView: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = AppColor.dividerGrey
        return divider
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        setupDividerView()
    }
}

// MARK: Setup
private extension JobFooterReusableView {
    func setupDividerView() {
        addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingConstant),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.trailingConstant),
            dividerView.heightAnchor.constraint(equalToConstant: Constants.height),
            dividerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dividerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: ReusableView
extension JobFooterReusableView: ReusableView {}
