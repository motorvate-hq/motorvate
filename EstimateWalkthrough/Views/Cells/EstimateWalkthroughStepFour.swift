//
//  EstimateWalkthroughStepFour.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let confirmButtonSize = CGSize(width: 110, height: 45)
}

class EstimateWalkthroughStepFour: EstimateWalkthroughStepCell {
    
    // MARK: UI Elements
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Customer confirms estimate\n\nYou will be notified once confirmed"
        return label
    }()
    private let estimateWalkthroughButtons = EstimateWalkthroughButtons(step: 4)
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.walkthroughArrow()
        imageView.transform = .init(scaleX: -1, y: -1)
        return imageView
    }()
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 15)
        button.layer.addShadow(
            backgroundColor: UIColor(red: 0.105, green: 0.206, blue: 0.807, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 5,
            shadowRadius: 10,
            shadowOffset: CGSize(width: 0, height: 4)
        )
        return button
    }()
    
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
        addSubview(confirmButton)
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
            make.right.equalTo(confirmButton.snp.left).inset(40)
            make.size.equalTo(60)
        }
        confirmButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(arrowImageView.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(15)
            make.size.equalTo(Constants.confirmButtonSize)
            make.bottom.equalToSuperview().inset(70)
        }
    }
}
