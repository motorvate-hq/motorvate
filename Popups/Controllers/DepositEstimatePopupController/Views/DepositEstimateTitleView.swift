//
//  DepositEstimateTitleView.swift
//  Motorvate
//
//  Created by Nikita Benin on 18.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class DepositEstimateTitleView: UIView {
    
    var serviceType: ServiceType? {
        didSet {
            imageView.image = serviceType?.isExcludingDeposit == true ? R.image.createEstimate() : R.image.chatPayment()
            titleLabel.text = serviceType?.isExcludingDeposit == true ? "Create Estimate" : "Deposit + Estimate"
        }
    }
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.chatPayment()
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.semiBold, ofSize: 15)
        label.text = "Deposit + Estimate"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String?) {
        titleLabel.text = title
    }
    
    // MARK: - UI Setup
    private func setView() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.equalToSuperview()
            make.size.equalTo(34)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(imageView.snp.right).offset(6)
            make.centerY.equalTo(imageView.snp.centerY)
            make.right.equalToSuperview()
        }
    }
}
