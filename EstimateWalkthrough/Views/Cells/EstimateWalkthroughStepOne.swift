//
//  EstimateWalkthroughStepOne.swift
//  Motorvate
//
//  Created by Nikita Benin on 21.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class EstimateWalkthroughStepOne: EstimateWalkthroughStepCell {
    
    // MARK: UI Elements
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.walkthroughArrow()
        imageView.transform = .init(scaleX: -1, y: 1)
        return imageView
    }()
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Tap “Start Estimate” on any of your shops Inquiries to enable Two-Way SMS and begin an estimate.\n\nTo watch how we automate your shops inquiries view tutorial here"
        return label
    }()
    private let estimateWalkthroughButtons = EstimateWalkthroughButtons(step: 1)
    
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
        contentView.addSubview(arrowImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(estimateWalkthroughButtons)
    }
    
    private func setupConstraints() {
        arrowImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(245)
            make.right.equalToSuperview().inset(70)
            make.size.equalTo(90)
        }
        commentLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(arrowImageView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(90)
        }
        estimateWalkthroughButtons.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(commentLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(40)
        }
    }
}
