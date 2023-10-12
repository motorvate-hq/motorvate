//
//  WalkthroughStepView.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

protocol WalkthroughStepViewDelegate: AnyObject {
    func didChangeStep(stepNumber: Int)
    func finishTutorial()
}

private struct Constants {
    static let actionButtonSize = CGSize(width: 82, height: 31)
    static let closeButtonSize = CGSize(width: 30, height: 30)
}

class WalkthroughStepView: UIView {

    // MARK: UI Elements
    private let carView = WalkthroughStepCarView()
    private let progressView = WalkthroughProgressView()
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.semiBold, ofSize: 13)
        return label
    }()
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeIcon(), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        return button
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.regular, ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    private let backButton: UIButton = {
        let button = UIButton()
        button.layer.addShadow(
            backgroundColor: UIColor(red: 0.105, green: 0.206, blue: 0.807, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 5,
            shadowRadius: 8
        )
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 12)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0.5, right: 0)
        return button
    }()
    private let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.walkthroughBackArrow()
        return imageView
    }()
    private let nextButton = WalkthroughNextButton()
    
    // MARK: Variables
    private var step: WalkthroughStep = .scanVin
    weak var delegate: WalkthroughStepViewDelegate?
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(step: WalkthroughStep) {
        self.step = step
        updateStep(step: step)
    }
    
    private func updateStep(step: WalkthroughStep) {
        progressView.updateProgressBar(step: step)
        
        backButton.isHidden = !step.showBackButton
        nextButton.isHidden = !step.showNextButton
        
        if step.showNextButton {
            nextButton.startAnimation()
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.18
        textLabel.attributedText =
            NSMutableAttributedString(
                string: step.text,
                attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            )
    }
    
    @objc func closeTutorial() {
        delegate?.finishTutorial()
    }
    
    @objc private func showNextStep() {
        guard step.rawValue < WalkthroughStep.allCases.count - 1 else { return }
        delegate?.didChangeStep(stepNumber: 1)
    }
    
    @objc private func showPreviousStep() {
        guard step.rawValue > 0 else { return }
        delegate?.didChangeStep(stepNumber: -1)
    }
    
    // MARK: UI Setup
    private func setView() {
        layer.cornerRadius = 4
        backgroundColor = UIColor(red: 0.913, green: 0.942, blue: 1, alpha: 1)
        addSubview(carView)
        addSubview(progressView)
        addSubview(stepLabel)
        closeButton.addTarget(self, action: #selector(closeTutorial), for: .touchUpInside)
        addSubview(closeButton)
        addSubview(textLabel)
        backButton.addTarget(self, action: #selector(showPreviousStep), for: .touchUpInside)
        addSubview(backButton)
        backButton.addSubview(backImageView)
        nextButton.addTarget(self, action: #selector(showNextStep), for: .touchUpInside)
        addSubview(nextButton)
    }
    
    private func setupConstraints() {
        carView.snp.makeConstraints { (make) -> Void in
            make.top.left.bottom.equalToSuperview()
        }
        progressView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(carView.snp.right).offset(10)
            make.right.equalTo(closeButton.snp.left).inset(-10)
        }
        closeButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(progressView.snp.centerY)
            make.right.equalToSuperview().inset(8)
            make.size.equalTo(Constants.closeButtonSize)
        }
        textLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(progressView.snp.bottom).offset(6)
            make.left.equalTo(carView.snp.right).offset(10)
            make.right.equalToSuperview().inset(26)
        }
        backButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(carView.snp.right).offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(Constants.actionButtonSize)
        }
        backImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(7)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(7)
        }
        nextButton.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(Constants.actionButtonSize)
        }
    }
}
