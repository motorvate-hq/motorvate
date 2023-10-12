//
//  DepositEstimateView.swift
//  Motorvate
//
//  Created by Nikita Benin on 10.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class DepositEstimateView: UIView {

    // MARK: - UI Elements
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let jobDetailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 13)
        label.text = "Irdium Silver"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 13)
        label.text = "$1700.00"
        label.textAlignment = .center
        return label
    }()
    private let depositLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 13)
        label.text = "$425.00"
        label.textAlignment = .center
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
    
    func setView(inquiryDetail: ServiceDetail, percentType: DepositEstimateType, showDeposit: Bool) {
        jobDetailsLabel.text = inquiryDetail.description
        if let price = inquiryDetail.price {
            let currencySymbol = "$"
            amountLabel.text = String(format: "\(currencySymbol)%.2f", price)
            let deposit: Double = Double(price) / 100 * Double(percentType.percent)
            depositLabel.text = String(format: "\(currencySymbol)%.2f", deposit)
        }
        depositLabel.isHidden = !showDeposit
    }
    
    // MARK: - UI Setup
    private func setView() {
        addSubview(hStackView)
        hStackView.addArrangedSubview(jobDetailsLabel)
        hStackView.addArrangedSubview(amountLabel)
        hStackView.addArrangedSubview(depositLabel)
    }
    
    private func setupConstraints() {
        hStackView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
