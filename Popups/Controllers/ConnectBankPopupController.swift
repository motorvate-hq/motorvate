//
//  ConnectBankPopupController.swift
//  Motorvate
//
//  Created by Nikita Benin on 03.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

import SafariServices

private struct Constants {
    static let cornerRadius: CGFloat = 26
    static let iconBackViewSize: CGFloat = 92
    static let iconImageViewSize: CGSize = CGSize(width: 48, height: 46)
    static let actionButtonSize: CGSize = CGSize(width: 130, height: 42)
    static let stripeImageSize: CGSize = CGSize(width: 136, height: 33)
}

protocol ConnectBankPopupDelegate: AnyObject {
    func showSafariController(url: URL)
}

class ConnectBankPopupController: PopupController {

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
        label.text = "Connect Bank or Debit Card"
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
                string: "Request payments from your customers with one tap and get paid instantly 🚗💨",
                attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            )
        label.textAlignment = .center
        return label
    }()
    private let stripeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.poweredByStripe()
        return imageView
    }()
    private let actionButton: PopupActionButton = {
        let button = PopupActionButton(style: .green)
        button.setTitle("Connect", for: .normal)
        return button
    }()
    private let learnMoreButton: PopupActionButton = {
        let button = PopupActionButton(style: .blue)
        button.setTitle("Learn more", for: .normal)
        return button
    }()
    
    // MARK: - Variables
    weak var delegate: ConnectBankPopupDelegate?
    private let service = StripeService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
    }
    
    @objc private func didPressActionButton() {
        guard let shopID = UserSession.shared.shopID,
              let email = UserSession.shared.user?.email else {
            presentAlert(title: "Error", message: "Invalid user data.")
            return
        }
        let request = CreateStripeAccountRequest(email: email, shopID: shopID)
        createStripeAccount(request: request)
    }
    
    private func createStripeAccount(request: CreateStripeAccountRequest) {
        actionButton.setAsLoading(true)
        service.createAccount(request: request) { [weak self] result in
            self?.actionButton.setAsLoading(false)
            switch result {
            case .success(let response):
                let request = CreateStripeAccountLinkRequest(accountId: response.accountId)
                self?.createStripeAccountLink(request: request)
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func createStripeAccountLink(request: CreateStripeAccountLinkRequest) {
        actionButton.setAsLoading(true)
        service.createAccountLink(request: request) { [weak self] result in
            self?.actionButton.setAsLoading(false)
            switch result {
            case .success(let response):
                guard let url = URL(string: response.url) else {
                    self?.presentAlert(title: "Error", message: "Invalid URL")
                    return
                }
                self?.animateDisappear { [weak self] _ in
                    self?.delegate?.showSafariController(url: url)
                }
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func didPressLearnMoreButton() {
        if let url = URL(string: "https://www.motorvate.io/home/motorvate-invoicing/") {
            present(SFSafariViewController(url: url), animated: true)
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        view.addSubview(backView)
        view.addSubview(iconBackView)
        iconBackView.addSubview(iconImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(textLabel)
        backView.addSubview(stripeImageView)
        learnMoreButton.addTarget(self, action: #selector(didPressLearnMoreButton), for: .touchUpInside)
        backView.addSubview(learnMoreButton)
        actionButton.addTarget(self, action: #selector(didPressActionButton), for: .touchUpInside)
        backView.addSubview(actionButton)
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
        stripeImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.stripeImageSize)
        }
        actionButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(stripeImageView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(Constants.actionButtonSize)
            make.bottom.equalToSuperview().inset(26)
        }
        learnMoreButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(stripeImageView.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.size.equalTo(Constants.actionButtonSize)
            make.bottom.equalToSuperview().inset(26)
        }
    }
}
