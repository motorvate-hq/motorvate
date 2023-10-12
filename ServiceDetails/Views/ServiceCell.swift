//
//  ServiceCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 28.05.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let editIconSize: CGSize = CGSize(width: 28, height: 28)
    static let deleteIconSize: CGSize = CGSize(width: 25, height: 28)
}

class ServiceCell: UITableViewCell, ReusableView {

    // MARK: - Static properties
    static let height: CGFloat = 84
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.semiBold, ofSize: 15)
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.regular, ofSize: 13)
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        return label
    }()
    private let editButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(red: 0.298, green: 0.29, blue: 0.29, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setImage(R.image.serviceEdit(), for: .normal)
        return button
    }()
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(red: 0.298, green: 0.29, blue: 0.29, alpha: 1)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setImage(R.image.serviceDelete(), for: .normal)
        return button
    }()
    
    // MARK: - Variables
    private var deleteActionHandler: (() -> Void)?
    private var editActionHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(
        item: ServiceDetail,
        deleteActionHandler: (() -> Void)? = nil,
        editActionHandler: (() -> Void)? = nil
    ) {
        titleLabel.text = item.description
        if let price = item.price {
            priceLabel.text = String(format: "$%.2f", price)
        }
        self.deleteActionHandler = deleteActionHandler
        self.editActionHandler = editActionHandler
    }
    
    @objc private func handleEditTap() {
        editActionHandler?()
    }
    
    @objc private func handleDeleteTap() {
        deleteActionHandler?()
    }
    
    // MARK: UI Setup
    private func setView() {
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        editButton.addTarget(self, action: #selector(handleEditTap), for: .touchUpInside)
        contentView.addSubview(editButton)
        deleteButton.addTarget(self, action: #selector(handleDeleteTap), for: .touchUpInside)
        contentView.addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(editButton.snp.left).inset(-16)
        }
        priceLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(29)
        }
        editButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalTo(deleteButton.snp.left).inset(-8)
            make.size.equalTo(Constants.editIconSize)
        }
        deleteButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(Constants.deleteIconSize)
        }
    }
}
