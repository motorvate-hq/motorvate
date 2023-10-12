//
//  EstimateWalkthroughStepTwo.swift
//  Motorvate
//
//  Created by Nikita Benin on 21.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let depositEstimateTitleViewSize: CGSize = CGSize(width: 200, height: 43)
}

class EstimateWalkthroughStepTwo: EstimateWalkthroughStepCell {
    
    // MARK: UI Elements
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "You can share packages or reply to the service Inquiry and begin working on your estimate with your team."
        return label
    }()
    private let estimateWalkthroughButtons = EstimateWalkthroughButtons(step: 2)
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.walkthroughArrow()
        imageView.transform = .init(scaleX: 1, y: -1)
        return imageView
    }()
    private let depositEstimateBackgroundView: UIView = {
        let view = UIView()
        view.layer.addShadow(
            backgroundColor: .white,
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.35),
            cornerRadius: 5,
            shadowRadius: 5,
            shadowOffset: CGSize(width: 0, height: 1)
        )
        return view
    }()
    private let depositEstimateTitleView = DepositEstimateTitleView()
    
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
        addSubview(depositEstimateBackgroundView)
        depositEstimateBackgroundView.addSubview(depositEstimateTitleView)
    }
    
    private func setupConstraints() {
        commentLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(90)
            make.right.equalToSuperview().inset(25)
        }
        estimateWalkthroughButtons.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(commentLabel.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(20)
        }
        arrowImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(estimateWalkthroughButtons.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(80)
        }
        depositEstimateBackgroundView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(arrowImageView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(Constants.depositEstimateTitleViewSize)
            make.bottom.equalToSuperview().inset(100)
        }
        depositEstimateTitleView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
    }
}
