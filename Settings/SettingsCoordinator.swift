//
//  SettingsCoordinator.swift
//  Motorvate
//
//  Created by Emmanuel on 2/25/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
    weak var parentCoordinator: JobsCoordinator?
    fileprivate let presenter: UINavigationController

    private let service = AccountService(with: Authenticator.default)
    private let stripeService = StripeService()

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let viewModel = SettingsViewModel(service)
        let settingsViewController = SettingsViewController(viewModel)
        settingsViewController.coordinator = self
        settingsViewController.hidesBottomBarWhenPushed = true
        presenter.pushViewController(settingsViewController, animated: true)
    }
}

extension SettingsCoordinator {
    func showAccountSettings() {
        let viewModel = AccountSettingsViewModel()
        let accountViewController = AccountSettingsViewController(viewModel)
        accountViewController.coordinator = self
        presenter.pushViewController(accountViewController, animated: true)
    }

    func showChangePassword() {
        let viewModel = ChangePasswordViewModel(service)
        let changePasswordViewController = ChangePasswordViewController(viewModel)
        presenter.pushViewController(changePasswordViewController, animated: true)
    }

    func showAddTeamMember() {
        let viewModel = SettingsViewModel(service)
        let showAddMember = AddMemberViewController(viewModel)
        presenter.pushViewController(showAddMember, animated: true)
    }
    
    func showConnectBank() {
        if presenter.presentedViewController == nil {
            let connectBankPopupController = ConnectBankPopupController()
            connectBankPopupController.delegate = self
            presenter.present(connectBankPopupController, animated: false)
        }
    }
    
    func showUpdateBank() {
        guard let shopID = UserSession.shared.shopID else {
            presenter.presentAlert(title: "Error", message: "Invalid user data.")
            return
        }
        let request = GetStripeAccountRequest(shopID: shopID)
        getStripeAccount(request: request)
    }
    
    private func getStripeAccount(request: GetStripeAccountRequest) {
        presenter.setAsLoading(true)
        stripeService.getStripeAccount(request: request) { [weak self] result in
            self?.presenter.setAsLoading(false)
            switch result {
            case .success(let response):
                let request = CreateStripeAccountLinkRequest(accountId: response.stripeID)
                self?.createStripeAccountLink(request: request)
            case .failure(let error):
                self?.presenter.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func createStripeAccountLink(request: CreateStripeAccountLinkRequest) {
        presenter.setAsLoading(true)
        stripeService.createAccountLink(request: request) { [weak self] result in
            self?.presenter.setAsLoading(false)
            switch result {
            case .success(let response):
                guard let url = URL(string: response.url) else {
                    self?.presenter.presentAlert(title: "Error", message: "Invalid URL")
                    return
                }
                self?.showSafariController(url: url)
            case .failure(let error):
                self?.presenter.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

extension SettingsCoordinator: ConnectBankPopupDelegate {
    func showSafariController(url: URL) {
        let vc = WebController(url: url)
        vc.delegate = self
        if presenter.presentedViewController != nil {
            presenter.presentedViewController?.dismiss(animated: false, completion: { [weak self] in
                self?.presenter.present(vc, animated: true)
            })
        } else {
            presenter.present(vc, animated: true)
        }
    }
}

extension SettingsCoordinator: WebControllerDelegate {
    func didDismiss() {
        if let settingsController = presenter.viewControllers.last as? SettingsViewController {
            settingsController.reloadConnectBank()
        }
    }
}
