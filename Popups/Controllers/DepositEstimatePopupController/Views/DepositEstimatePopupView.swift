//
//  DepositEstimatePopupView.swift
//  Motorvate
//
//  Created by Nikita Benin on 23.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let backgroundCornerRadius: CGFloat = 20
}

class DepositEstimatePopupView: UIView {
    
    // MARK: - UI Elements
    private let depositEstimateTitleView = DepositEstimateTitleView()
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 14)
        button.layer.addShadow(
            backgroundColor: UIColor(red: 0.872, green: 0.872, blue: 0.872, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 5,
            shadowRadius: 9
        )
        return button
    }()
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    private let depositEstimateHeaderView = DepositEstimateHeaderView()
    private let sepratorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        return view
    }()
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 7
        return stackView
    }()
    private let selectDepositView = DepositEstimateSwitchView(
        title: "Select deposit:",
        segmentTitles: ["25%", "50%"]
    )
    private let includeFeeView = DepositEstimateSwitchView(
        title: "Include fees in total:",
        segmentTitles: ["No", "Yes"]
    )
    private let feePriceView = DepositEstimatePriceView(title: "Service fee:", subtitle: "")
    private let estimatePriceView = DepositEstimatePriceView(title: "Estimate:", subtitle: "You will recieve")
    private let customerPriceView = DepositEstimatePriceView(title: "Ask for:", subtitle: "Customer will recieve")
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    private let previewButton: PopupActionButton = {
        let button = PopupActionButton(style: .yellow)
        button.setTitle("Preview", for: .normal)
        return button
    }()
    private let sendButton: PopupActionButton = {
        let button = PopupActionButton(style: .purple)
        button.setTitle("Send Esimate / Deposit Link", for: .normal)
        return button
    }()
    
    // MARK: - Variables
    private var viewModel: DepositEstimatePopupViewModel?
    var handleEditDetails: (() -> Void)?
    var handleGetPreviewLink: (() -> Void)?
    var handleSendEstimationLink: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(viewModel: DepositEstimatePopupViewModel) {
        self.viewModel = viewModel
        editButton.setTitle("    " + viewModel.editButtonTitle + "    ", for: .normal)
        sendButton.setTitle(viewModel.sendButtonTitle, for: .normal)
        
        depositEstimateHeaderView.setView(showDeposit: viewModel.depositEstimateType != .percent100 && !viewModel.isExcludingDeposit)
        selectDepositView.isHidden = !(viewModel.depositEstimateType != .percent100 && !viewModel.isExcludingDeposit)
        depositEstimateTitleView.serviceType = viewModel.serviceType
        depositEstimateTitleView.setTitle(title: viewModel.title)
        for serviceDetail in viewModel.serviceDetails {
            let row = DepositEstimateView()
            row.setView(inquiryDetail: serviceDetail, percentType: .percent25, showDeposit: viewModel.depositEstimateType != .percent100 && !viewModel.isExcludingDeposit)
            detailsStackView.addArrangedSubview(row)
        }
        
        selectDepositView.isEnabled = viewModel.isEditingEnabled
        includeFeeView.isEnabled = viewModel.isEditingEnabled
        editButton.alpha = viewModel.isEditingEnabled ? 1 : 0.4
        sendButton.alpha = viewModel.isEditingEnabled ? 1 : 0.4
        
        selectDepositView.isHidden = viewModel.isExcludingDeposit
        includeFeeView.isHidden = viewModel.isExcludingDeposit
        feePriceView.isHidden = viewModel.isExcludingDeposit
        customerPriceView.isHidden = viewModel.isExcludingDeposit
    }
    
    func handleDepositSizeChange() {
        guard let viewModel = viewModel else { return }
        for (index, row) in detailsStackView.subviews.enumerated() {
            if let row = row as? DepositEstimateView {
                row.setView(
                    inquiryDetail: viewModel.serviceDetails[index - 1],
                    percentType: viewModel.depositEstimateType,
                    showDeposit: viewModel.depositEstimateType != .percent100 && !viewModel.isExcludingDeposit
                )
            }
        }
        handleFeeChange()
    }
    
    func handleFeeChange() {
        guard let viewModel = viewModel else { return }
        let includeFee: Bool = viewModel.depositFeeType == .include
        let totalPrice: Double = viewModel.serviceDetails.map({ Double($0.price ?? 0) }).reduce(0, +)
        var depositPrice: Double = totalPrice
        if viewModel.depositEstimateType != .none {
            depositPrice = totalPrice / 100 * Double(viewModel.depositEstimateType.percent)
        }

        let expectedTotal = PriceCalculator.calculateExpectedTotalPrice(price: depositPrice, includeFee: includeFee)
        let fee = PriceCalculator.calculateFeeForPrice(price: depositPrice, includeFee: includeFee)
        
        estimatePriceView.value = String(format: "$%.2f", max(expectedTotal - fee, 0))
        customerPriceView.value = String(format: "$%.2f", expectedTotal)
        feePriceView.value = String(format: "$%.2f", fee)
    }
    
    @objc private func editDetailsHandler() {
        handleEditDetails?()
    }
    
    @objc private func previewHandler() {
        handleGetPreviewLink?()
    }
    
    @objc private func sendEstimationLinkHandler() {
        handleSendEstimationLink?()
    }
    
    func isLoadingPreview(_ isLoading: Bool) {
        previewButton.setAsLoading(isLoading)
    }
    
    // MARK: - UI Setup
    private func setView() {
        layer.cornerRadius = Constants.backgroundCornerRadius
        backgroundColor = .white
        
        addSubview(depositEstimateTitleView)
        editButton.addTarget(self, action: #selector(editDetailsHandler), for: .touchUpInside)
        addSubview(editButton)
        detailsStackView.addArrangedSubview(depositEstimateHeaderView)
        addSubview(detailsStackView)
        addSubview(sepratorLineView)
        addSubview(vStackView)
        selectDepositView.segmentChangeHandler = { [weak self] selectedSegment in
            self?.viewModel?.depositEstimateType = selectedSegment == 0 ? .percent25 : .percent50
            self?.handleDepositSizeChange()
        }
        vStackView.addArrangedSubview(selectDepositView)
        includeFeeView.segmentChangeHandler = { [weak self] selectedSegment in
            self?.viewModel?.depositFeeType = selectedSegment == 0 ? .include : .exclude
            self?.handleFeeChange()
        }
        vStackView.addArrangedSubview(includeFeeView)
        vStackView.addArrangedSubview(feePriceView)
        vStackView.addArrangedSubview(estimatePriceView)
        vStackView.addArrangedSubview(customerPriceView)
        previewButton.addTarget(self, action: #selector(previewHandler), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(previewButton)
        sendButton.addTarget(self, action: #selector(sendEstimationLinkHandler), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(sendButton)
        addSubview(buttonsStackView)
    }
    
    private func setupConstraints() {
        depositEstimateTitleView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(15)
        }
        editButton.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(depositEstimateTitleView.snp.centerY)
        }
        detailsStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(depositEstimateTitleView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
            make.height.greaterThanOrEqualTo(40)
        }
        sepratorLineView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(detailsStackView.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(0.5)
        }
        vStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(sepratorLineView.snp.bottom).offset(7)
            make.left.right.equalToSuperview()
        }
        buttonsStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(vStackView.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(43)
            make.bottom.equalToSuperview().inset(17 + Constants.backgroundCornerRadius)
        }
        previewButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
        }
    }
}
