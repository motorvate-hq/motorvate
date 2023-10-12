//
//  PaymentConfirmationPopupController.swift
//  Motorvate
//
//  Created by Nikita Benin on 26.04.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerRadius: CGFloat = 26
    static let iconBackViewSize: CGFloat = 92
    static let iconImageViewSize: CGSize = CGSize(width: 48, height: 46)
}

class PaymentConfirmationPopupController: PopupController {

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
        imageView.image = R.image.connectBankPopupIcon()
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.bold, ofSize: 19)
        label.textAlignment = .center
        label.text = "Success"
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
                string: "Payment Complete. Start Onboard when vehicle is dropped off to complete service.",
                attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            )
        label.textAlignment = .center
        return label
    }()
    private let okButton: PopupActionButton = {
        let button = PopupActionButton(style: .blue)
        button.setTitle("OK", for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
    }
    
    @objc private func handleOkAction() {
        animateAndDismiss()
    }
    
    // MARK: - UI Setup
    private func setView() {
        view.addSubview(backView)
        view.addSubview(iconBackView)
        iconBackView.addSubview(iconImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(textLabel)
        okButton.addTarget(self, action: #selector(handleOkAction), for: .touchUpInside)
        backView.addSubview(okButton)
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
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().inset(48)
        }
        okButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.bottom.equalToSuperview().inset(25)
        }
    }
}
