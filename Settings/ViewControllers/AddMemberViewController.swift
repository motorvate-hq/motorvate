//
//  AddMemberViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 3/1/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

class AddMemberViewController: UIViewController {
    private lazy var emailLabel = AppComponent.makeFormTextFieldHeaderLabel(with: "Email:")
    private lazy var emailTextField = AppComponent.textfield(with: "johndoe@gmail.com")
    private let inviteButton: UIButton = {
        let button = AppButton(title: "Invite")
        button.configure(as: .primary)
        return button
    }()

    fileprivate var viewModel: SettingsViewModel

    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// Fileprivate
fileprivate extension AddMemberViewController {
    func setup() {
        view.backgroundColor = .systemBackground
        title = "Invite Team Member"

        view.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 23),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        ])

        view.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])

        // Create Account
        view.addSubview(inviteButton)
        NSLayoutConstraint.activate([
            inviteButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            inviteButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
        ])

        inviteButton.addTarget(self, action: #selector(inviteButtonPressed), for: .touchUpInside)
    }

    @objc func inviteButtonPressed() {
        guard let email = emailTextField.text, email.isValidEmail() else {
            BaseViewController.presentAlert(message: "Enter a valid email", from: self)
            return
        }

        setAsLoading(true)
        viewModel.inviteMember(with: email)
    }
}

// MARK: SettingsViewModelDelegate
extension AddMemberViewController: SettingsViewModelDelegate {
    func didComplete(with result: Result<Bool, NetworkResponse>) {
        setAsLoading(false)
        switch result {
        case .success:
            emailTextField.text = ""
            BaseViewController.presentAlert(
                message: "Invite sent",
                okHandler: {
                    self.navigationController?.popViewController(animated: true)
                },
                from: self
            )
        case .failure(let error):
            BaseViewController.presentAlert(message: error.message, from: self)
        }
    }
}
