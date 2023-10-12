//
//  LogInViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 1/24/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let passwordFieldError: String = "Password field is required"
    static let invalidEmailError: String = "Please Enter a valid email"
}

final class LogInViewController: BaseAccountViewController {

    lazy var emailLabel = AppComponent.makeFormTextFieldHeaderLabel(with: "Email:")
    lazy var emailTextField = AppComponent.makeFormTextField(.emailAddress, textContentType: .emailAddress)
    lazy var passwordLabel = AppComponent.makeFormTextFieldHeaderLabel(with: "Password:")
    lazy var passwordTextField = AppComponent.makeFormTextField(.default, true, textContentType: .password)
    lazy var headerLabel = AppComponent.makeFormHeaderLabel(with: "Log Into Motorvate")
    private let logInButton: UIButton = {
        let button = AppButton(title: "Log in")
        button.configure(as: .primary)
        return button
    }()

    private let forgotPasswordButton: UIButton = {
        let button = AppButton(title: "Forgot Password")
        button.configure(as: .secondary(titleColor: AppColor.primaryBlue, backgroundColor: .white))
        return button
    }()

    fileprivate let viewModel: AccountViewModel
    fileprivate weak var getStartedViewControllerDelegate: GetStartedViewControllerDelegate?

    init(with viewModel: AccountViewModel, delegate: GetStartedViewControllerDelegate?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.getStartedViewControllerDelegate = delegate
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

fileprivate extension LogInViewController {
    func setupUI() {
        // header
        containerView.addSubview(headerLabel)

        // Email
        containerView.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 23)
        ])
        containerView.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 43)
        ])

        // Password
        containerView.addSubview(passwordLabel)
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 13)
        ])
        containerView.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 43)
        ])

        // Create Account
        containerView.addSubview(logInButton)
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            logInButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        logInButton.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)

        containerView.addSubview(forgotPasswordButton)
        NSLayoutConstraint.activate([
            forgotPasswordButton.topAnchor.constraint(equalTo: logInButton.topAnchor),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
    }

    func getCredentails() -> Authenticator.Credentials? {
        guard let email = emailTextField.text?.lowercased(), email.isValidEmail() else {
            BaseViewController.presentAlert(message: Constants.invalidEmailError, from: self)
            return nil
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            BaseViewController.presentAlert(message: Constants.passwordFieldError, from: self)
            return nil
        }
        return Authenticator.Credentials(email, password)
    }
}

extension LogInViewController {
    @objc private func logInButtonPressed() {
        guard let credentials = getCredentails() else {
            return
        }
        
        setAsLoading(true)
        view.endEditing(true)
        viewModel.signIn(with: credentials)
    }

    @objc private func forgotPasswordButtonPressed() {
        guard let email = emailTextField.text?.lowercased(), email.isValidEmail() else {
            BaseViewController.presentAlert(message: Constants.invalidEmailError, from: self)
            return
        }
        viewModel.requestForgetPassword(for: email)
    }
}

// MARK: - AccountViewModelDelegate
extension LogInViewController: AccountViewModelDelegate {
    func userAuthenticated(with state: AuthState) {
        setAsLoading(false)
        getStartedViewControllerDelegate?.userAuthenticated(with: state)
    }

    func userFailedToAuthenticat(with error: String) {
        setAsLoading(false)
        BaseViewController.presentAlert(message: error, from: self)
    }

    func didSendForgetPasswordCode(with message: String, state: PasswordRequestState) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let acknowledgeAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
            self?.getStartedViewControllerDelegate?.confirmForgotPassword(for: state.resultValue)
        }
        alert.addAction(acknowledgeAction)
        present(alert, animated: true, completion: nil)
    }
}
