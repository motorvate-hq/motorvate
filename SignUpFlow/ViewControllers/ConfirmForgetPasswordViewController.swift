//
//  ForgetPasswordViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 3/3/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let minContentHeight: CGFloat = 350
}

class ConfirmForgetPasswordViewController: BaseAccountViewController {

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    private let contentView = UIView()
    lazy var headerLabel = AppComponent.makeFormHeaderLabel(with: "Confirm forget password")
    lazy var codeLabel = AppComponent.makeFormTextFieldHeaderLabel(with: "Code:")
    lazy var codeTextField = AppComponent.makeFormTextField()
    lazy var passwordLabel = AppComponent.makeFormTextFieldHeaderLabel(with: "New password:")
    lazy var passwordTextField = AppComponent.makeFormTextField(.default, true)
    lazy var passwordValidationView: PasswordValidationView = PasswordValidationView()
    private let confirmButtonButton: UIButton = {
        let button = AppButton(title: "Submit")
        button.configure(as: .primary)
        return button
    }()

    fileprivate var email: String
    fileprivate var viewModel: AccountViewModel

    init(_ viewModel: AccountViewModel, email: String) {
        self.viewModel = viewModel
        self.email = email
        super.init(nibName: nil, bundle: nil)

        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
    }
}

private extension ConfirmForgetPasswordViewController {
    func setupUI() {
        containerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // header
        contentView.addSubview(headerLabel)

        // Email
        contentView.addSubview(codeLabel)
        contentView.addSubview(codeTextField)

        // Password
        contentView.addSubview(passwordLabel)
        passwordTextField.addTarget(self, action: #selector(passwordEditingBegin), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(passwordEditingDidEnd), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        contentView.addSubview(passwordTextField)
        
        passwordValidationView.alpha = 0
        contentView.addSubview(passwordValidationView)

        // Create Account
        contentView.addSubview(confirmButtonButton)
        
        confirmButtonButton.addTarget(self, action: #selector(didPressConfirmButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.equalToSuperview()
            make.width.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(self.scrollView)
            make.height.equalTo(Constants.minContentHeight)
            make.width.equalToSuperview()
        }
        codeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerLabel.snp.bottom).offset(23)
        }
        codeTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(codeLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(43)
        }
        passwordLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(codeTextField.snp.bottom).offset(13)
        }
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(43)
        }
        passwordValidationView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordTextField.snp.bottom).offset(13)
            make.width.equalToSuperview()
        }
        confirmButtonButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.right.equalToSuperview()
        }
    }

    @objc func didPressConfirmButton() {
        guard let code = codeTextField.text, !code.isEmpty else {
            BaseViewController.presentAlert(message: "All fields are required", from: self)
            return
        }
        
        guard let password = passwordTextField.text, password.isValidPassword() else {
            BaseViewController.presentAlert(message: "Password doesn't match requirements", from: self)
            return
        }
        
        viewModel.confirmForgotPassword(for: email, code: code, newPassword: password)
    }
}

extension ConfirmForgetPasswordViewController: AccountViewModelDelegate {
    func didConfirmForgetPasswordCode(with message: String) {
        codeTextField.text = ""
        passwordTextField.text = ""
        BaseViewController.presentAlert(message: message, from: self)
    }

    func userFailedToAuthenticat(with error: String) {
        BaseViewController.presentAlert(message: error, from: self)
    }
}

// MARK: - PasswordValidationView logics
extension ConfirmForgetPasswordViewController {
    @objc private func passwordEditingBegin() {
        confirmButtonButton.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(passwordTextField.snp.bottom).offset(passwordValidationView.frame.height + 13 * 2)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
                strongSelf.passwordValidationView.alpha = 1
            })
        })
    }
    
    @objc private func passwordEditingDidEnd() {
        confirmButtonButton.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(passwordTextField.snp.bottom).offset(13)
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.passwordValidationView.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
                strongSelf.view.layoutIfNeeded()
            })
        })
    }
    
    @objc private func passwordDidChange() {
        guard let password = passwordTextField.text else { return }
        passwordValidationView.updateValidationStatus(
            hasCharacters: password.hasSevenSymbols(),
            hasUpperCase: password.hasUppercaseSymbol() && password.hasLowercaseSymbol(),
            hasSymbol: password.hasSpecialSymbol() && password.hasNumber())
    }
}

// MARK: - Keyboard notifications
extension ConfirmForgetPasswordViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
    }
}
