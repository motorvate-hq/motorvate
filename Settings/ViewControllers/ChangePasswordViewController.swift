//
//  ChangePasswordViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 11/30/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

typealias ChangePasswordCompletion = () -> Void

class ChangePasswordViewController: UIViewController {
    private enum Constants {
        static let minContentHeight: CGFloat = 380
        
        static let successMessage = "Your password has been updated!"
        static let failedMessage = "Failed to update password!"
        static let confirmPasswordError = "Confirm password does not match"
        static let inputFieldError = "All input fields are required"
        static let passwordRequirementsError = "New password doesn't match requirements"
    }

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    private let contentView = UIView()
    private lazy var currentPasswordTextField = AppComponent.makeSecuretextfield(with: "Current Password")
    private lazy var newPasswordTextField = AppComponent.makeSecuretextfield(with: "New Password")
    private lazy var passwordValidationView: PasswordValidationView = PasswordValidationView()
    private lazy var confirmPasswordTextField = AppComponent.makeSecuretextfield(with: "Confirm New Password")
    private lazy var approveButton: UIButton = {
        let button = AppButton(title: "Approve")
        button.configure(as: .primary)
        button.addTarget(self, action: #selector(didPressApprove), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: ChangePasswordViewModel
    private let completion: ChangePasswordCompletion?

    init(_ viewModel: ChangePasswordViewModel, completion: ChangePasswordCompletion? = nil) {
        self.viewModel = viewModel
        self.completion = completion

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
    }

    @objc func didPressApprove() {
        guard let entity = makePasswordEntity() else {
            return
        }

        viewModel.changePassword(entity) { [weak self] (result) in
            self?.handleResult(result)
        }
    }

    fileprivate func setupUI() {
        title = "Change Password"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(currentPasswordTextField)
        newPasswordTextField.addTarget(self, action: #selector(passwordEditingBegin), for: .editingDidBegin)
        newPasswordTextField.addTarget(self, action: #selector(passwordEditingDidEnd), for: .editingDidEnd)
        newPasswordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        contentView.addSubview(newPasswordTextField)
        
        passwordValidationView.alpha = 0
        contentView.addSubview(passwordValidationView)

        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(approveButton)
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
        currentPasswordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(12)
        }
        newPasswordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(currentPasswordTextField.snp.bottom).offset(17)
            make.height.equalTo(currentPasswordTextField.snp.height)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(12)
        }
        passwordValidationView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(13)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(12)
        }
        confirmPasswordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(17)
            make.height.equalTo(currentPasswordTextField.snp.height)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(12)
        }
        approveButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(17)
            make.height.equalTo(43)
            make.width.equalToSuperview().dividedBy(3)
            make.right.equalToSuperview().inset(12)
        }
    }
}

fileprivate extension ChangePasswordViewController {
    func makePasswordEntity() -> ChangePasswordViewModel.PasswordEntity? {
        guard let current = currentPasswordTextField.text, !current.isEmpty,
            let proposed = newPasswordTextField.text, !proposed.isEmpty,
            let confirmProposed = confirmPasswordTextField.text, !confirmProposed.isEmpty else {
                BaseViewController.presentAlert(message: Constants.inputFieldError, from: self)
                return nil
        }
        
        guard let password = newPasswordTextField.text, password.isValidPassword() else {
            BaseViewController.presentAlert(message: Constants.passwordRequirementsError, from: self)
            return nil
        }

        if proposed != confirmProposed {
            BaseViewController.presentAlert(message: Constants.confirmPasswordError, from: self)
            return nil
        }

        return ChangePasswordViewModel.PasswordEntity(current: current, proposed: proposed)
    }

    private func handleResult(_ result: Bool) {
        if result {
          AnalyticsManager.logEvent(.passwordChanged)
            BaseViewController.presentAlert(
                message: Constants.successMessage,
                okHandler: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                },
                from: self
            )
        } else {
            BaseViewController.presentAlert(message: Constants.failedMessage, from: self)
        }
        performCompletion(result)
    }

    private func performCompletion(_ result: Bool) {
        if let handler = completion, result {
            handler()
        }
    }
}

// MARK: - PasswordValidationView logics
extension ChangePasswordViewController {
    @objc private func passwordEditingBegin() {
        confirmPasswordTextField.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(passwordValidationView.frame.height + 17 * 2)
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
        confirmPasswordTextField.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(17)
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
        guard let password = newPasswordTextField.text else { return }
        passwordValidationView.updateValidationStatus(
            hasCharacters: password.hasSevenSymbols(),
            hasUpperCase: password.hasUppercaseSymbol() && password.hasLowercaseSymbol(),
            hasSymbol: password.hasSpecialSymbol() && password.hasNumber())
    }
}

// MARK: - Keyboard notifications
extension ChangePasswordViewController {
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
