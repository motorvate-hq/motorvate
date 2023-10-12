//
//  AccountSettingSwitchCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 06.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let titleLabelLeadingSpacing: CGFloat = 24
    static let switchInset: CGFloat = 12
}

class AccountSettingSwitchCell: UITableViewCell {
    
    // MARK: UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.semiBold, ofSize: 15)
        label.textColor = .black
        return label
    }()
    private let uiSwitch: UISwitch = UISwitch()

    // MARK: Lifecycle
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

        contentView.addSubview(titleLabel)
        contentView.addSubview(uiSwitch)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(Constants.titleLabelLeadingSpacing)
            make.centerY.equalToSuperview()
        }
        uiSwitch.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(Constants.switchInset)
            make.centerY.equalToSuperview()
        }
    }
}

extension AccountSettingSwitchCell {
    func configure(_ item: AccountSettingItem) {
        titleLabel.text = item.stringValue
    }
}

// MARK: - ReusableView
extension AccountSettingSwitchCell: ReusableView {}
