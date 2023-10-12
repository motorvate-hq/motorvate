//
//  CustomerJobDetailsTotalView.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class CustomerJobDetailsTotalView: UIView {

    // MARK: UI Elements
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.bold, ofSize: 16)
        return label
    }()
    private let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.regular, ofSize: 16)
        label.text = "$0.00"
        return label
    }()
    private let feeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.bold, ofSize: 12)
        label.text = "service fee"
        return label
    }()
    private let feeValueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.regular, ofSize: 16)
        label.text = "$0.00"
        return label
    }()
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.regular, ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(title: String, comment: String, fullPrice: Double, feePrice: Double) {
        totalLabel.text = title
        commentLabel.text = comment
        
        totalValueLabel.text = String(format: "$%.2f", fullPrice)
        feeValueLabel.text = String(format: "$%.2f", feePrice)
    }
    
    // MARK: UI Setup
    private func setupView() {
        addSubview(totalLabel)
        addSubview(feeLabel)
        addSubview(totalValueLabel)
        addSubview(feeValueLabel)
        addSubview(commentLabel)
    }
    
    private func setupConstraints() {
        totalLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        feeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(totalLabel.snp.bottom).offset(3)
            make.left.equalToSuperview().offset(16)
        }
        totalValueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        feeValueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(totalValueLabel.snp.bottom).offset(3)
            make.right.equalToSuperview().inset(16)
        }
        commentLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(feeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}
