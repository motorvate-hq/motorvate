//
//  EstimateWalkthroughStepFive.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let allSetButtonSize: CGSize = CGSize(width: 145, height: 45)
}

class EstimateWalkthroughStepFive: EstimateWalkthroughStepCell {
    
    // MARK: UI Elements
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = "Customer can pay deposit with credit or debit.\n\nAffirm is available for the final job order 🚗💨"
        return label
    }()
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.walkthroughArrow()
        imageView.transform = .init(scaleX: 1, y: -1)
        return imageView
    }()
    private let payButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pay with Credit / Debit Card", for: .normal)
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
    private let allSetButton: UIButton = {
        let button = UIButton()
        button.setTitle("You’re all set! 5/5", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 15)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(red: 0.948, green: 0.948, blue: 0.948, alpha: 1).cgColor
        button.layer.addShadow(
            backgroundColor: UIColor(red: 0.356, green: 0.567, blue: 0.017, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 5,
            shadowRadius: 10,
            shadowOffset: CGSize(width: 0, height: 4)
        )
        return button
    }()
    
    // MARK: - Variables
    private var handleAllSetAction: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(type: EstimateWalkthroughCellType, handleAllSetAction: @escaping () -> Void) {
        setBackgroundImages(type: type)
        self.handleAllSetAction = handleAllSetAction
    }
    
    @objc private func allSetButtonHandler() {
        handleAllSetAction?()
    }
    
    // MARK: UI Setup
    private func setViews() {
        addSubview(commentLabel)
        addSubview(arrowImageView)
        addSubview(payButton)
        allSetButton.addTarget(self, action: #selector(allSetButtonHandler), for: .touchUpInside)
        addSubview(allSetButton)
    }
    
    private func setupConstraints() {
        commentLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(90)
            make.right.equalToSuperview().inset(35)
        }
        arrowImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(commentLabel.snp.bottom)
            make.left.equalToSuperview().offset(100)
            make.size.equalTo(60)
        }
        payButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(arrowImageView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
            make.height.equalTo(47)
        }
        allSetButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(payButton.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.allSetButtonSize)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}
