//
//  EstimatePopupController.swift
//  Motorvate
//
//  Created by Nikita Benin on 18.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

import SafariServices

private struct Constants {
    static let cornerRadius: CGFloat = 26
    static let iconBackViewSize: CGSize = CGSize(width: 226, height: 90)
    static let depositEstimateTitleViewSize: CGSize = CGSize(width: 200, height: 43)
    static let actionButtonSize: CGSize = CGSize(width: 130, height: 45)
}

class EstimatePopupController: PopupController {

    // MARK: - UI Elements
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    private let iconBackView: UIView = {
        let view = UIView()
        view.layer.addShadow(
            backgroundColor: UIColor(red: 1, green: 0.682, blue: 0.075, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 6,
            shadowRadius: 11,
            shadowOffset: CGSize(width: 0, height: 4)
        )
        return view
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
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.bold, ofSize: 19)
        label.textAlignment = .center
        label.text = "Deposits & Estimates Available"
        return label
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 15)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.41
        label.attributedText =
            NSMutableAttributedString(
                string: "Tap Message on any new Inquiry to prepare quote or estimate and send  for confirmation. Request up to 50% deposit on your next job",
                attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            )
        label.textAlignment = .center
        return label
    }()
    private let learnMoreButton: PopupActionButton = {
        let button = PopupActionButton(style: .blue)
        button.setTitle("Learn more", for: .normal)
        return button
    }()
    
    // MARK: - Variables
    var learnMoreHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
    }
    
    @objc private func didPressLearnMoreButton() {
        animateDisappear(completion: { [weak self] _ in
            self?.dismiss(animated: false) { [weak self] in
                self?.learnMoreHandler?()
            }
        })
    }
    
    // MARK: UI Setup
    private func setView() {
        view.addSubview(backView)
        view.addSubview(iconBackView)
        iconBackView.addSubview(depositEstimateBackgroundView)
        depositEstimateBackgroundView.addSubview(depositEstimateTitleView)
        backView.addSubview(titleLabel)
        backView.addSubview(textLabel)
        learnMoreButton.addTarget(self, action: #selector(didPressLearnMoreButton), for: .touchUpInside)
        backView.addSubview(learnMoreButton)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(180)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
        iconBackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backView.snp.top).inset(-Constants.iconBackViewSize.height / 2)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.iconBackViewSize)
        }
        depositEstimateBackgroundView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.depositEstimateTitleViewSize)
        }
        depositEstimateTitleView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(74)
            make.left.equalToSuperview().offset(27)
            make.right.equalToSuperview().inset(27)
        }
        textLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().inset(48)
        }
        learnMoreButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.actionButtonSize)
            make.bottom.equalToSuperview().inset(26)
        }
    }
}
