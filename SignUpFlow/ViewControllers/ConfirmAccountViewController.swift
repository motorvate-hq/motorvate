//
//  ConfirmAccountViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 2/27/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

class ConfirmAccountViewController: BaseAccountViewController {

    lazy var headerLabel = AppComponent.makeFormHeaderLabel(with: "Enter confirmation code")
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.regular, ofSize: 15)
        label.text = "Confirmation code was sent to your email."
        label.numberOfLines = 0
        return label
    }()
    lazy var emailLabel = AppComponent.makeFormTextFieldHeaderLabel(with: "Code:")
    lazy var codeTextField = AppComponent.makeFormTextField()
    private let confirmButtonButton: UIButton = {
        let button = AppButton(title: "Confirm")
        button.configure(as: .primary)
        return button
    }()

    weak var delegate: GetStartedViewControllerDelegate?
    fileprivate let credentials: Authenticator.Credentials?
    fileprivate let viewModel: AccountViewModel

    init(viewModel: AccountViewModel, credentials: Authenticator.Credentials?) {
        self.viewModel = viewModel
        self.credentials = credentials
        super.init(nibName: nil, bundle: nil)

        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let backItem = UIBarButtonItem()
        backItem.title = "Step 2 of 2"
        backItem.setTitleTextAttributes(
            [NSAttributedString.Key.font: AppFont.archivo(.bold, ofSize: 15),
             NSAttributedString.Key.baselineOffset: NSNumber(value: 2.6)
            ], for: .normal)
        navigationItem.backBarButtonItem = backItem
    }

    fileprivate func setup() {
        // header
        containerView.addSubview(headerLabel)
        
        containerView.addSubview(commentLabel)
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 5),
            commentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        // Email
        containerView.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 23)
        ])
        containerView.addSubview(codeTextField)
        NSLayoutConstraint.activate([
            codeTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            codeTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            codeTextField.heightAnchor.constraint(equalToConstant: 43)
        ])
        // Create Account
        containerView.addSubview(confirmButtonButton)
        NSLayoutConstraint.activate([
            confirmButtonButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 24),
            confirmButtonButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        confirmButtonButton.addTarget(self, action: #selector(didPressConfirmButton), for: .touchUpInside)
    }

    @objc func didPressConfirmButton() {
        setAsLoading(true)
        view.endEditing(true)
        let code = codeTextField.text ?? ""
        viewModel.confirmAccount(with: credentials, code: code)
    }
}

extension ConfirmAccountViewController: AccountViewModelDelegate {
    func userAuthenticated(with state: AuthState) {
        setAsLoading(false)
        if state == .confirmed {
            delegate?.showBusinessInfo(with: viewModel)
        } else {
            delegate?.userAuthenticated(with: state)
        }
    }

    func userFailedToAuthenticat(with error: String) {
        setAsLoading(false)
        BaseViewController.presentAlert(message: error, from: self)
    }
}
