//
//  InquiryFormsPopupController.swift
//  Motorvate
//
//  Created by Nikita Benin on 25.05.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerRadius: CGFloat = 26
    static let iconBackViewSize: CGFloat = 92
    static let iconImageViewSize: CGSize = CGSize(width: 43, height: 48)
    static let viewNumberButtonSize: CGSize = CGSize(width: 130, height: 42)
    static let understandButtonSize: CGSize = CGSize(width: 250, height: 65)
}

class InquiryFormsPopupController: PopupController {

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
        label.text = "Branded Inquiry Forms"
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
                string: "Automated forms with your shop name are sent to new customers who text your shop. All your shops Inquiries will be sorted so you can follow-up with an estimate 🚗💨",
                attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            )
        label.textAlignment = .center
        return label
    }()
    private let phoneLabel: CopyableLabel = {
        let label = CopyableLabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.regular, ofSize: 15)
        if let shop = UserSession.shared.shop {
            let phone = (shop.shopTelephone ?? "").setFormat(with: "+X XXX XXX XXXX")
            label.copyText = phone
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.41
            let attributedString = NSMutableAttributedString(
                string: "\(phone)\nTap on phone number to copy it.",
                attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            )
            label.attributedText = attributedString
        }
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    private let viewNumberButton: PopupActionButton = {
        let button = PopupActionButton(style: .blue)
        button.setTitle("View My Number", for: .normal)
        return button
    }()
    private let understandButton: PopupActionButton = {
        let button = PopupActionButton(style: .green)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = .center
        let attributedText = NSMutableAttributedString(
            string: "I understand I must reply to\nInquiries to enable Two-Way SMS",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        button.setAttributedTitle(attributedText, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        return button
    }()
    
    // MARK: - Variables
    var disappearHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disappearHandler?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
    }
    
    @objc private func didPressViewNumberButton() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.phoneLabel.alpha = 1
            self?.viewNumberButton.alpha = 0
        })
    }
    
    @objc private func didPressUnderstandButton() {
        UserSettings().didShowInquiryFormsPopup = true
        animateAndDismiss()
    }
    
    // MARK: - UI Setup
    private func setView() {
        view.addSubview(backView)
        view.addSubview(iconBackView)
        iconBackView.addSubview(iconImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(textLabel)
        backView.addSubview(phoneLabel)
        viewNumberButton.addTarget(self, action: #selector(didPressViewNumberButton), for: .touchUpInside)
        backView.addSubview(viewNumberButton)
        understandButton.addTarget(self, action: #selector(didPressUnderstandButton), for: .touchUpInside)
        backView.addSubview(understandButton)
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
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().inset(18)
        }
        phoneLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().inset(18)
        }
        viewNumberButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(phoneLabel.snp.centerY)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.viewNumberButtonSize)
        }
        understandButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(phoneLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.understandButtonSize)
            make.bottom.equalToSuperview().inset(26)
        }
    }
}
