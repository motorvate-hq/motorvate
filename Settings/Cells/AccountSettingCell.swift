//
//  File.swift
//  Motorvate
//
//  Created by Emmanuel on 11/24/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let separatorHeight: CGFloat = 1
    static let titleLabelLeadingSpacing: CGFloat = 24
    static let arrowInset: CGFloat = 17
    static let arrowSize: CGSize = CGSize(width: 17, height: 15)
}

class AccountSettingCell: UITableViewCell {

    // MARK: UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.semiBold, ofSize: 15)
        label.textColor = .black
        return label
    }()
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.accountSettingsArrow()
        return imageView
    }()
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UI Setup
    private func setView() {
        selectionStyle = .none

        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(separator)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(Constants.titleLabelLeadingSpacing)
            make.centerY.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(Constants.arrowSize)
            make.right.equalToSuperview().inset(Constants.arrowInset)
            make.centerY.equalToSuperview()
        }
        separator.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(Constants.separatorHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension AccountSettingCell {
    func configure(_ item: AccountSettingItem) {
        titleLabel.text = item.stringValue
    }
}

// MARK: - ReusableView
extension AccountSettingCell: ReusableView {}
