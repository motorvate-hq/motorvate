//
//  ApplicationCoordinator.swift
//  Motorvate
//
//  Created by Emmanuel on 1/23/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationCoordinatorDelegate: AnyObject {
    func updateRootViewController(for state: AuthState)
}

class ApplicationCoordinator {
    fileprivate let window: UIWindow
    fileprivate var rootViewController: UIViewController?
    fileprivate var accountCoordinator: AccountCoordinator?
    private let authenticator: Authenticator

    /// This might not be wise to pass in Authorization
    init(_ window: UIWindow, _ authorization: Authenticator) {
        self.window = window
        self.authenticator = authorization
        initializeRootViewController(with: authorization)
        NotificationCenter.default.addObserver(self, selector: #selector(didLogOut), name: .DidLogOutSuccessfully, object: nil)
    }
}

fileprivate extension ApplicationCoordinator {
    func initializeRootViewController(with authorization: Authenticator) {
        authorization.initializeCognito { [weak self] (state) in
            guard let self = self else { return }

            switch state {
            case .signedIn:
                self.initializeForSigninState()
            case .signedOut:
                self.authenticator.signOut()
                self.initializeForAccountState()
            case .shopIdentifierRequired:
                self.initializeForAccountState(forceShopCreation: true)
            case .unconfirmed, .confirmed, .newPassword:
                break
            }
        }
    }

    func initializeForAccountState(forceShopCreation: Bool = false) {
        let rootViewController = UINavigationController()
        self.accountCoordinator = AccountCoordinator(with: rootViewController, delegate: self, forceShopCreation: forceShopCreation)
        self.accountCoordinator?.start()
        self.rootViewController = rootViewController
        start()
    }

    func initializeForSigninState() {
        self.rootViewController = MainTabBarController()
        _configurePurchaseSDKForSignInUser()
        start()
    }

    @objc private func didLogOut() {
        DispatchQueue.main.async { [weak self] in
            self?.initializeForAccountState()
            self?.start()
        }
    }

    private func _configurePurchaseSDKForSignInUser() {
        guard let appUserId = UserSession.shared.userID else { return }
        PurchaseKit.set(appUserId: appUserId)
    }
}

// MARK: - Coordinator
extension ApplicationCoordinator: Coordinator {
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

// MARK: - ApplicationCoordinatorDelegate
extension ApplicationCoordinator: ApplicationCoordinatorDelegate {
    func updateRootViewController(for state: AuthState) {
        switch state {
        case .signedIn:
            initializeForSigninState()
        case .signedOut:
            initializeForAccountState()
        case .shopIdentifierRequired:
            initializeForAccountState(forceShopCreation: true)
        default: break // this needs to be changed
        }
    }
}
