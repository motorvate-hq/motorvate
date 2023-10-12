//
//  AccountSettingDeleteCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 06.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

protocol AccountSettingDeleteCellDelegate: AnyObject {
    func handleDeleteAction()
}

private struct Constants {
    static let buttonSize = CGSize(width: 155, height: 38)
    static let buttonTopSpacing: CGFloat = 30
    static let buttonFont = AppFont.archivo(.semiBold, ofSize: 12)
    static let buttonBackgroundColor: UIColor = UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1)
    static let buttonCornerRadius: CGFloat = 5.5
}

class AccountSettingDeleteCell: UITableViewCell {
    
    // MARK: UI Elements
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = Constants.buttonFont
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        return button
    }()
    
    // MARK: Variables
    private weak var delegate: AccountSettingDeleteCellDelegate?

    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressDelete() {
        delegate?.handleDeleteAction()
    }

    // MARK: UI Setup
    private func setView() {
        selectionStyle = .none

        deleteButton.addTarget(self, action: #selector(didPressDelete), for: .touchUpInside)
        contentView.addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        deleteButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(Constants.buttonTopSpacing)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.buttonSize)
            make.bottom.equalToSuperview()
        }
    }
}

extension AccountSettingDeleteCell {
    func configure(_ item: AccountSettingItem, delegate: AccountSettingDeleteCellDelegate) {
        deleteButton.setTitle(item.stringValue, for: .normal)
        self.delegate = delegate
    }
}

// MARK: - ReusableView
extension AccountSettingDeleteCell: ReusableView {}
