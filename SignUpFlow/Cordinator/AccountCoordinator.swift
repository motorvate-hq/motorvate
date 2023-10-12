//
//  AccountCoordinator.swift
//  Motorvate
//
//  Created by Emmanuel on 1/24/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

class AccountCoordinator {
    fileprivate weak var getStartedViewController: GetStartedViewController?
    fileprivate weak var appCordinatorDelegate: ApplicationCoordinatorDelegate?

    private let presenter: UINavigationController
    private let forceShopCreation: Bool

    fileprivate var viewModel: AccountViewModel {
        let service = AccountService(with: Authenticator.default)
        return AccountViewModel(with: service)
    }

    init(with presenter: UINavigationController, delegate: ApplicationCoordinatorDelegate?, forceShopCreation: Bool) {
        self.presenter = presenter
        self.appCordinatorDelegate = delegate
        self.forceShopCreation = forceShopCreation
        
        self.viewModel.refreshUserInfo()
    }
}

// MARK: - Coordinator
extension AccountCoordinator: Coordinator {
    func start() {
        _start()
    }
}

// MARK: - GetStartedViewControllerDelegate
extension AccountCoordinator: GetStartedViewControllerDelegate {
    func createAccountButtonPressed() {
        let createAccountViewController = CreateAccountViewController(with: viewModel, delegate: self)
        presenter.pushViewController(createAccountViewController, animated: true)
    }

    func signInButtonPressed() {
        let loginViewController = LogInViewController(with: viewModel, delegate: self)
        presenter.pushViewController(loginViewController, animated: true)
    }

    func userAuthenticated(with state: AuthState) {
        switch state {
        case .signedIn, .signedOut, .shopIdentifierRequired:
            appCordinatorDelegate?.updateRootViewController(for: state)
        case .newPassword:
            showNewPasswordFlow()
        case .unconfirmed, .confirmed: break
        }
    }

    func showBusinessInfo(with viewModel: AccountViewModel?) {
        let businessInfoViewController = BusinessInformationViewController.instantiate()
        businessInfoViewController.viewModel = viewModel
        businessInfoViewController.delegate = self
        presenter.pushViewController(businessInfoViewController, animated: true)
    }

    func confirmAccount(with credentials: Authenticator.Credentials?) {
        let confirmationViewController = ConfirmAccountViewController(viewModel: viewModel, credentials: credentials)
        confirmationViewController.delegate = self
        presenter.pushViewController(confirmationViewController, animated: true)
    }

    func showNewPasswordFlow() {
        let service = AccountService(with: Authenticator.default)
        let viewModel = ChangePasswordViewModel(service)
        let changePasswordViewController = ChangePasswordViewController(viewModel) {
            DispatchQueue.main.async { [weak self] in
                self?.userAuthenticated(with: .signedIn)
            }
        }
        presenter.pushViewController(changePasswordViewController, animated: true)
    }

    func confirmForgotPassword(for email: String) {
        let confirmForgetPasswordViewController = ConfirmForgetPasswordViewController(viewModel, email: email)
        presenter.pushViewController(confirmForgetPasswordViewController, animated: true)
    }
}

extension AccountCoordinator {
    private func _start() {
        if forceShopCreation {
            showBusinessInfo(with: viewModel)
        } else {
            let getStartedViewController = GetStartedViewController()
            getStartedViewController.delegate = self
            presenter.pushViewController(getStartedViewController, animated: false)
            self.getStartedViewController = getStartedViewController
        }
    }
}
