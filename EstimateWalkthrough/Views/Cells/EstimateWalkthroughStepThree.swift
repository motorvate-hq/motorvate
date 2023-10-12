//
//  EstimateWalkthroughStepThree.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let depositEstimateTitleViewSize: CGSize = CGSize(width: 200, height: 43)
}

class EstimateWalkthroughStepThree: EstimateWalkthroughStepCell {
    
    // MARK: UI Elements
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Tap edit to add service or and select either  25% or 50% of your estimate uprfont."
        return label
    }()
    private let estimateWalkthroughButtons = EstimateWalkthroughButtons(step: 3)
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.walkthroughArrow()
        imageView.transform = .init(scaleX: -1, y: -1)
        return imageView
    }()
    private let depositEstimatePopupView = DepositEstimatePopupView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(
        type: EstimateWalkthroughCellType,
        handleNextAction: @escaping () -> Void,
        handleGotItAction: @escaping () -> Void
    ) {
        setBackgroundImages(type: type)
        estimateWalkthroughButtons.actionHandler = { actionType in
            switch actionType {
            case .gotIt:    handleGotItAction()
            case .nextStep: handleNextAction()
            }
        }
    }
    
    // MARK: UI Setup
    private func setViews() {
        addSubview(arrowImageView)
        addSubview(commentLabel)
        addSubview(estimateWalkthroughButtons)
        
        let viewModel = DepositEstimatePopupViewModel(serviceDetails: [
            ServiceDetail(id: nil, description: "Irdium Silver", price: 1700),
            ServiceDetail(id: nil, description: "Car wash", price: 100)
        ], excludingDeposit: false)
        depositEstimatePopupView.setView(viewModel: viewModel)
        addSubview(depositEstimatePopupView)
    }
    
    private func setupConstraints() {
        commentLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().inset(90)
        }
        estimateWalkthroughButtons.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(commentLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(20)
        }
        arrowImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(estimateWalkthroughButtons.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(50)
            make.size.equalTo(60)
        }
        depositEstimatePopupView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(arrowImageView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
