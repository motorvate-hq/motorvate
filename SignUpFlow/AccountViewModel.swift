//
//  AccountViewModel.swift
//  Motorvate
//
//  Created by Emmanuel on 1/24/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

import FirebaseMessaging

protocol AccountViewModelDelegate: AnyObject {
    func userAuthenticated(with state: AuthState)
    func userFailedToAuthenticat(with error: String)
    func didConfirmForgetPasswordCode(with message: String)
    func didSendForgetPasswordCode(with message: String, state: PasswordRequestState)
}

extension AccountViewModelDelegate {
    // Extended to make optional
    func userAuthenticated(with state: AuthState) {}
    func didConfirmForgetPasswordCode(with message: String) {}
    func didSendForgetPasswordCode(with message: String, state: PasswordRequestState) {}
}

final class AccountViewModel {
    fileprivate var serviceTypes: [String] = []
    private(set) var parameters: Parameters = [:]

    fileprivate let accountService: AccountService
    fileprivate let userService: UserService
    weak var delegate: AccountViewModelDelegate?

    init(with service: AccountService, _ userService: UserService = UserService()) {
        self.accountService = service
        self.userService = userService
    }

    var hasServiceType: Bool {
        return !serviceTypes.isEmpty
    }

    func update(service type: String) {
        if let index = serviceTypes.firstIndex(of: type) {
            serviceTypes.remove(at: index)
        } else {
            serviceTypes.append(type)
        }
    }

    @discardableResult
    func setParams(_ params: Parameters) -> Parameters {
        parameters.merge(params) { (_, new) in new }
        return parameters
    }
}

extension AccountViewModel {
    func createAccount(with credentials: Authenticator.Credentials) {
        accountService.authorizer.createAccount(with: credentials) { (result) in
            switch result {
            case .success(let state):
                AnalyticsManager.logEvent(.createdAccount)
                self.delegate?.userAuthenticated(with: state)
            case .failure(let error):
                switch error {
                case .creationError(let message):
                    self.delegate?.userFailedToAuthenticat(with: message)
                default:
                    self.delegate?.userFailedToAuthenticat(with: error.localizedDescription)
                }
            }
        }
    }

    func signIn(with credentials: Authenticator.Credentials) {
        accountService.authorizer.signIn(with: credentials) { [weak self] (result) in
            switch result {
            case .success(let state):
                self?.evaluateSigninSuccess(state)
            case .failure(let error):
                switch error {
                case .signInFailed(let message):
                    self?.delegate?.userFailedToAuthenticat(with: message)
                default: break
                }
            }
        }
    }

    func createShop(userIdentifier: String, deviceToken: String) {

        if !hasServiceType { serviceTypes = ["Nothing"] }
        let params: Parameters = [ "serviceTypes": serviceTypes, "deviceToken": deviceToken, "userID": userIdentifier ]
        userService.createShop(params: setParams(params)) { [weak self] (result) in
            switch result {
            case .success:
                self?.refreshUserInfo()
            case .failure(let error):
                self?.delegate?.userFailedToAuthenticat(with: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }

    func confirmAccount(with credentials: Authenticator.Credentials?, code: String) {
        let username = credentials?.username ?? ""
        accountService.authorizer.confirmSignup(with: username, code: code) { [weak self] (result) in
            switch result {
            case .success:
                AnalyticsManager.logEvent(.confirmedAccount)
                if let credentials = credentials {
                    self?.accountService.authorizer.signIn(with: credentials, completion: nil)
                }
                self?.delegate?.userAuthenticated(with: .confirmed)
            case .failure:
                self?.delegate?.userFailedToAuthenticat(with: """
                                                            We are unable to validate the code.
                                                            Please try again or request a new code
                                                            """)
            }
        }
    }

    func requestForgetPassword(for email: String) {
        let message = "If email belongs to a confirmed account you will receive reset password code on your email."
        accountService.authorizer.requestForgotPasswordCode(for: email) { [weak self] (result) in
            switch result {
            case .success(let state):
                AnalyticsManager.logEvent(.forgotPassword)
                self?.delegate?.didSendForgetPasswordCode(with: message, state: state)
            case .failure:
                self?.delegate?.didSendForgetPasswordCode(with: message, state: .none)
            }
        }
    }

    func confirmForgotPassword(for email: String, code: String, newPassword: String) {
        accountService.authorizer.confirmForgotPasswordCode(for: email, code: code, newPassword: newPassword) { [weak self] (result) in
            switch result {
            case .success:
                self?.delegate?.didConfirmForgetPasswordCode(with: "You have successfully updated the password of your account ")
            case .failure:
                self?.delegate?.userFailedToAuthenticat(with: "Failed to updated Password")
            }
        }
    }

    func refreshUserInfo() {
        getUser(by: UserSession.shared.userID)
    }
}

extension AccountViewModel {
    private func getUser(by userID: String?) {
        guard let userID = userID else {
            print("Logging --> failed to retrieve userID from user Session")
            delegate?.userAuthenticated(with: .signedOut)
            return
        }

        userService.getUser(by: userID) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?._handleGetUserSuccess(user)
                case .failure(let error):
                    print("AccountViewModel getUser Error -> \(error.localizedDescription)")
                    self?.delegate?.userAuthenticated(with: .signedOut)
                }
            }
        }
    }

    private func _handleGetUserSuccess(_ user: User) {
        // If the shopID is nil then that means we need to force the user into the shop creating process
        guard let shopId = user.shopID else {
            delegate?.userAuthenticated(with: .shopIdentifierRequired)
            return
        }
        
        Messaging.messaging().subscribe(toTopic: shopId) { error in
            if let error = error {
                print("Subscribe to topic error: \(error.localizedDescription)")
                return
            }
            print("Subscribed to topic: \(shopId)")
        }
        
        delegate?.userAuthenticated(with: .signedIn)
    }

    private func evaluateSigninSuccess(_ state: AuthState) {
        switch state {
        case .signedIn:
            AnalyticsManager.logEvent(.login)
            getUser(by: UserSession.shared.userID)
        case .newPassword(let challengeResponse):
           confirmSignIn(challengeResponse)
        case .signedOut, .unconfirmed, .confirmed:
            delegate?.userAuthenticated(with: state)
        case .shopIdentifierRequired: break
        }
    }

    private func confirmSignIn(_ challengeResponse: String) {
        accountService.authorizer.confirmSignin(challengeResponse: challengeResponse) { [weak self] (result) in
            guard case .success(let state) = result else {
                self?.delegate?.userFailedToAuthenticat(with: "message")
                return
            }

            guard state == .signedIn else {
                self?.delegate?.userAuthenticated(with: state)
                return
            }

            self?.delegate?.userAuthenticated(with: .newPassword(challengeResponse: ""))
        }
    }
}
