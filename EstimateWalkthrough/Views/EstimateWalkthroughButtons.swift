//
//  EstimateWalkthroughButtons.swift
//  Motorvate
//
//  Created by Nikita Benin on 21.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

enum EstimateWalkthroughButtonType {
    case gotIt
    case nextStep
}

class EstimateWalkthroughButtons: UIStackView {
    
    // MARK: - UI Elements
    private let gotItButton: UIButton = {
        let button = UIButton()
        button.setTitle("Got it", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 16)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(red: 0.948, green: 0.948, blue: 0.948, alpha: 1).cgColor
        button.layer.addShadow(
            backgroundColor: UIColor(red: 1, green: 0.682, blue: 0.075, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 6,
            shadowRadius: 11,
            shadowOffset: CGSize(width: 0, height: 5)
        )
        return button
    }()
    private let nextStepButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next Step 1/6", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFont.poppinsRegular(ofSize: 16)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(red: 0.948, green: 0.948, blue: 0.948, alpha: 1).cgColor
        button.layer.addShadow(
            backgroundColor: UIColor(red: 0.105, green: 0.206, blue: 0.807, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 6,
            shadowRadius: 11,
            shadowOffset: CGSize(width: 0, height: 5)
        )
        return button
    }()
    
    // MARK: - Variables
    var actionHandler: ((EstimateWalkthroughButtonType) -> Void)?
    
    // MARK: - Lifecycle
    init(step: Int) {
        super.init(frame: .zero)
        
        nextStepButton.setTitle("Next Step \(step)/5", for: .normal)
        
        setViews()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleGotItTap() {
        actionHandler?(.gotIt)
    }
    
    @objc private func handleNextStepTap() {
        actionHandler?(.nextStep)
    }
    
    // MARK: UI Setup
    private func setViews() {
        axis = .horizontal
        spacing = 15
        gotItButton.addTarget(self, action: #selector(handleGotItTap), for: .touchUpInside)
        addArrangedSubview(gotItButton)
        nextStepButton.addTarget(self, action: #selector(handleNextStepTap), for: .touchUpInside)
        addArrangedSubview(nextStepButton)
    }
    
    private func setupConstraints() {
        gotItButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 135, height: 45))
        }
        nextStepButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 135, height: 45))
        }
    }
}
