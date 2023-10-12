//
//  CompleteJobPopupController.swift
//  Motorvate
//
//  Created by Nikita Benin on 08.02.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerRadius: CGFloat = 26
    static let iconBackViewSize: CGFloat = 92
    static let iconImageViewSize: CGSize = CGSize(width: 43, height: 48)
    static let actionButtonSize: CGSize = CGSize(width: 140, height: 42)
}

class CompleteJobPopupController: PopupController {

    // MARK: UI Elements
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
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.inquiryPopupIcon()
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.bold, ofSize: 19)
        label.textAlignment = .center
        label.text = "Confirm Job Details?"
        return label
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 15)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        label.attributedText =
            NSMutableAttributedString(
                string: "We recommend sending the job details to your customer or client prior to completing job. Would you like us to send a text for confirmation first ?",
                attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            )
        label.textAlignment = .center
        return label
    }()
    private let sendInvoiceButton: PopupActionButton = {
        let button = PopupActionButton(style: .blue)
        button.setTitle("Send Invoice", for: .normal)
        return button
    }()
    private let completeButton: PopupActionButton = {
        let button = PopupActionButton(style: .green)
        button.setTitle("Complete Job Now", for: .normal)
        return button
    }()
    
    // MARK: Variables
    private let handleSendInvoice: () -> Void
    private let handleComplete: () -> Void
    
    // MARK: Lifecycle
    init(
        handleSendInvoice: @escaping () -> Void,
        handleComplete: @escaping () -> Void,
        needAnimateAppear: Bool = true
    ) {
        self.handleSendInvoice = handleSendInvoice
        self.handleComplete = handleComplete        
        super.init(nibName: nil, bundle: nil, needAnimateAppear: needAnimateAppear)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
    }
    
    @objc private func didPressSendInvoiceButton() {
        handleSendInvoice()
        animateAndDismiss()
    }
    
    @objc private func didPressCompleteButton() {
        handleComplete()
        animateAndDismiss()
    }
    
    // MARK: UI Setup
    private func setView() {
        view.addSubview(backView)
        view.addSubview(iconBackView)
        iconBackView.addSubview(iconImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(textLabel)
        sendInvoiceButton.addTarget(self, action: #selector(didPressSendInvoiceButton), for: .touchUpInside)
        backView.addSubview(sendInvoiceButton)
        completeButton.addTarget(self, action: #selector(didPressCompleteButton), for: .touchUpInside)
        backView.addSubview(completeButton)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(180)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
        iconBackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backView.snp.top).inset(-Constants.iconBackViewSize / 2)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.iconBackViewSize)
        }
        iconImageView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.iconImageViewSize)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(74)
            make.left.equalToSuperview().offset(27)
            make.right.equalToSuperview().inset(27)
        }
        textLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(19)
            make.right.equalToSuperview().inset(19)
        }
        sendInvoiceButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(14)
            make.size.equalTo(Constants.actionButtonSize)
            make.bottom.equalToSuperview().inset(26)
        }
        completeButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textLabel.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(14)
            make.size.equalTo(Constants.actionButtonSize)
            make.bottom.equalToSuperview().inset(26)
        }
    }
}
