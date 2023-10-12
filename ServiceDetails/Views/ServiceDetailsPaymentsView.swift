//
//  ServiceDetailsPaymentsView.swift
//  Motorvate
//
//  Created by Nikita Benin on 05.04.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class ServiceDetailsPaymentsView: UIView {

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.bold, ofSize: 17)
        label.textColor = .black
        label.text = "Payments"
        return label
    }()
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 7
        return stackView
    }()
    private let paidPriceView = DepositEstimatePriceView(subtitle: "Customer has already paid")
    private let remainingPriceView = DepositEstimatePriceView(title: "Remaining Balance", subtitle: "Customer will pay upon completing job")
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.771, green: 0.771, blue: 0.771, alpha: 1)
        return view
    }()
    private let seePaymentsIvoiceButton: UIButton = {
        let button = UIButton()
        button.setTitle("See payment invoice", for: .normal)
        button.setTitleColor(UIColor(red: 0.38, green: 0.235, blue: 0.733, alpha: 1), for: .normal)
        button.titleLabel?.font = AppFont.archivo(.regular, ofSize: 14)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        return button
    }()
    
    // MARK: - Variables
    var handleGetPreviewLink: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleShowInvoice() {
        handleGetPreviewLink?()
    }
    
    func setView(inquiryPaidDetail: InquiryPaidDetail) {
        let paidAmount = inquiryPaidDetail.price * Double(inquiryPaidDetail.percent) * 0.01
        let remainingAmount = inquiryPaidDetail.price - paidAmount
        paidPriceView.setView(title: "Paid (\(inquiryPaidDetail.percent)%)", value: String(format: "$%.2f", paidAmount))
        remainingPriceView.setView(value: String(format: "$%.2f", remainingAmount))
    }
    
    // MARK: - UI Setup
    private func setView() {
        backgroundColor = .white
        layer.cornerRadius = 5
        addSubview(titleLabel)
        addSubview(vStackView)
        vStackView.addArrangedSubview(paidPriceView)
        vStackView.addArrangedSubview(remainingPriceView)
        addSubview(separatorView)
        seePaymentsIvoiceButton.addTarget(self, action: #selector(handleShowInvoice), for: .touchUpInside)
        addSubview(seePaymentsIvoiceButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
        }
        vStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
        }
        separatorView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(vStackView.snp.bottom).offset(7)
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
        }
        seePaymentsIvoiceButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(separatorView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(43)
            make.bottom.equalToSuperview()
        }
    }
}
