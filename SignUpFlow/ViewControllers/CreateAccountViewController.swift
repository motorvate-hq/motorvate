//
//  CreateAccountViewController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-07.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let minContentHeight: CGFloat = 450
    static let textFieldHeight: CGFloat = 43
}

final class CreateAccountViewController: BaseAccountViewController {

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    private let contentView = UIView()
    lazy var emailLabel = AppComponent.makeFormTextFieldHeaderLabel(with: "Email")
    lazy var emailTextField = AppComponent.makeFormTextField(.emailAddress)
    lazy var passwordLabel = AppComponent.makeFormTextFieldHeaderLabel(with: "Password")
    lazy var passwordTextField = AppComponent.makeFormTextField(.default, true)
    lazy var passwordValidationView: PasswordValidationView = PasswordValidationView()
    lazy var phoneNumberlabel = AppComponent.makeFormTextFieldHeaderLabel(with: "Phone number")
    lazy var phoneNumberTextField = AppComponent.makeFormTextField(.phonePad, inputFormat: .phoneNumber)
    lazy var createAccountButton = AppButton(title: "Create account")
    lazy var headerLabel = AppComponent.makeFormHeaderLabel(with: "Create Account")

    fileprivate let viewModel: AccountViewModel
    fileprivate weak var delegate: GetStartedViewControllerDelegate?

    init(with viewModel: AccountViewModel, delegate: GetStartedViewControllerDelegate?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.delegate = delegate
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerNotifications()
        setUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)

        let backItem = UIBarButtonItem()
        backItem.title = "Step 1 of 2"
        backItem.setTitleTextAttributes(
            [NSAttributedString.Key.font: AppFont.archivo(.bold, ofSize: 15),
             NSAttributedString.Key.baselineOffset: NSNumber(value: 2.6)
            ], for: .normal)
        navigationItem.backBarButtonItem = backItem
    }

    // MARK: - UI
    private func setUI() {
        containerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // header
        contentView.addSubview(headerLabel)

        // Email
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)

        // Password
        contentView.addSubview(passwordLabel)
        
        passwordTextField.addTarget(self, action: #selector(passwordEditingBegin), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(passwordEditingDidEnd), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        contentView.addSubview(passwordTextField)
        
        passwordValidationView.alpha = 0
        contentView.addSubview(passwordValidationView)

        // Phone number
        contentView.addSubview(phoneNumberlabel)
        contentView.addSubview(phoneNumberTextField)

        // Create Account
        contentView.addSubview(createAccountButton)
        createAccountButton.configure(as: .primary)
        createAccountButton.addTarget(self, action: #selector(onCreateAccountPressed), for: .touchUpInside)
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
        emailLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerLabel.snp.bottom).offset(23)
        }
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
        passwordLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailTextField.snp.bottom).offset(13)
        }
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
        passwordValidationView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordTextField.snp.bottom).offset(13)
            make.width.equalToSuperview()
        }
        phoneNumberlabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordTextField.snp.bottom).offset(13)
        }
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(phoneNumberlabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(Constants.textFieldHeight)
        }
        createAccountButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(24)
            make.right.equalTo(phoneNumberTextField.snp.right)
        }
    }

    // MARK: - Objc
    @objc private func onCreateAccountPressed() {
        guard let email = emailTextField.text, email.isValidEmail() else {
            BaseViewController.presentAlert(message: "Invalid email format", from: self)
            return
        }
        
        guard let password = passwordTextField.text, password.isValidPassword() else {
            BaseViewController.presentAlert(message: "Password doesn't match requirements", from: self)
            return
        }

        guard let phone = (phoneNumberTextField as? CustomTextField)?.textValue, phone.isValidPhone() else {
            BaseViewController.presentAlert(message: "Input a valid phone. e.g: +1 234 567 8940", from: self)
            return
        }
        
        setAsLoading(true)
        view.endEditing(true)
        let credentials = Authenticator.Credentials(email, password, "+1\(phone)")        
        viewModel.createAccount(with: credentials)
    }

    func getCredentails() -> Authenticator.Credentials? {
        guard let email = emailTextField.text, email.isValidEmail(),
            let password = passwordTextField.text, password.isValidPassword(),
            let phone = (phoneNumberTextField as? CustomTextField)?.textValue, phone.isValidPhone() else {
                return nil
        }
        return Authenticator.Credentials(email, password, phone)
    }
}

// MARK: - AccountViewModelDelegate
extension CreateAccountViewController: AccountViewModelDelegate {
    func userAuthenticated(with state: AuthState) {
        setAsLoading(false)
        switch state {
        case .confirmed:
            delegate?.showBusinessInfo(with: viewModel)
        case .unconfirmed:
            delegate?.confirmAccount(with: getCredentails())
        case .signedOut:
            delegate?.userAuthenticated(with: .signedOut)
        case .signedIn, .newPassword, .shopIdentifierRequired: break
        }
    }

    func userFailedToAuthenticat(with error: String) {
        setAsLoading(false)
        BaseViewController.presentAlert(message: error, from: self)
    }
}

// MARK: - PasswordValidationView logics
extension CreateAccountViewController {
    @objc private func passwordEditingBegin() {
        phoneNumberlabel.snp.updateConstraints { (make) -> Void in
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
        phoneNumberlabel.snp.updateConstraints { (make) -> Void in
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
extension CreateAccountViewController {
    func registerNotifications() {
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
