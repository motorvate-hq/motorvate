//
//  DepositEstimateHeaderView.swift
//  Motorvate
//
//  Created by Nikita Benin on 10.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class DepositEstimateHeaderView: UIView {

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
        label.font = AppFont.archivo(.medium, ofSize: 15)
        label.text = "Job Details"
        label.textAlignment = .center
        return label
    }()
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.medium, ofSize: 15)
        label.text = "Amount"
        label.textAlignment = .center
        return label
    }()
    private let depositLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.medium, ofSize: 15)
        label.text = "Deposit"
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(showDeposit: Bool) {
        depositLabel.isHidden = !showDeposit
    }
    
    // MARK: - UI Setup
    private func setupView() {
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
