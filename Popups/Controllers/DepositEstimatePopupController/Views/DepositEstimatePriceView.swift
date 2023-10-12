//
//  DepositEstimatePriceView.swift
//  Motorvate
//
//  Created by Nikita Benin on 25.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class DepositEstimatePriceView: UIView {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.semiBold, ofSize: 16)
        label.text = "Total deposit:"
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 12)
        label.text = "Some subtitle here"
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 16)
        label.text = "$450.00"
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Variables
    var value: String = "" {
        didSet {
            valueLabel.text = value
        }
    }
    
    // MARK: - Lifecycle
    init(title: String? = nil, subtitle: String) {
        super.init(frame: .zero)
        
        setView(title: title, subtitle: subtitle)
        setUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(title: String? = nil, subtitle: String? = nil, value: String? = nil) {
        if let title = title {
            titleLabel.text = title
        }
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
        }
        if let value = value {
            valueLabel.text = value
        }
    }
    
    // MARK: - UI Setup
    private func setUI() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(valueLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        subtitleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel.snp.left)
            make.bottom.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(7)
            make.right.equalToSuperview().inset(15)
        }
    }
}
