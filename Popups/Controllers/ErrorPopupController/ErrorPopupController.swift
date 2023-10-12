//
//  ErrorPopupController.swift
//  Motorvate
//
//  Created by Nikita Benin on 08.04.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerRadius: CGFloat = 26
    static let iconBackViewSize: CGFloat = 92
    static let iconImageViewSize: CGSize = CGSize(width: 48, height: 46)
}

class ErrorPopupController: PopupController {

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
        imageView.image = R.image.errorPopoverIcon()
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.bold, ofSize: 19)
        label.textAlignment = .center
        label.text = "Unknown Error"
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
                string: "Please screenshot or share this error with us soon as you can.",
                attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            )
        label.textAlignment = .center
        return label
    }()
    private let buttonsView = UIView()
    private let supportButton: SupportButton = SupportButton()
    private let okButton: PopupActionButton = {
        let button = PopupActionButton(style: .blue)
        button.setTitle("OK", for: .normal)
        return button
    }()
    
    // MARK: - Variables
    private var okActionHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    init(
        title: String?,
        message: String?,
        handler: (() -> Void)? = nil,
        needAnimateAppear: Bool = true
    ) {
        super.init(nibName: nil, bundle: nil, needAnimateAppear: needAnimateAppear)
        titleLabel.text = title ?? "Unknown Error"
        textLabel.text = message ?? "Please screenshot or share this error with us soon as you can."
        okActionHandler = handler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
    }
    
    @objc private func handleSupportAction() {
        animateAndDismiss()
        if let url = URL(string: "https://wa.link/amd0wm") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func handleOkAction() {
        animateAndDismiss()
        okActionHandler?()
    }
    
    // MARK: - UI Setup
    private func setView() {
        view.addSubview(backView)
        view.addSubview(iconBackView)
        iconBackView.addSubview(iconImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(textLabel)
        backView.addSubview(buttonsView)
        supportButton.addTarget(self, action: #selector(handleSupportAction), for: .touchUpInside)
        buttonsView.addSubview(supportButton)
        okButton.addTarget(self, action: #selector(handleOkAction), for: .touchUpInside)
        buttonsView.addSubview(okButton)
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
        buttonsView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(25)
        }
        supportButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        okButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalTo(supportButton.snp.right).inset(-10)
            make.width.equalTo(60)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
