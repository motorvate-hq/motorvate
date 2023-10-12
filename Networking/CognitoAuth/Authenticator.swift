//
//  Authorization.swift
//  Motorvate
//
//  Created by Emmanuel on 1/20/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import AWSMobileClientXCF

final class Authenticator {
    public static var `default` = Authenticator()

    private let _mobileClient: AWSMobileClient

    private init () {
        self._mobileClient = AWSMobileClient(configuration: AuthenticationConfiguration.loadConfiguration())
        NotificationCenter.default.addObserver(self, selector: #selector(forceSignout), name: .ForceLogoutAuthorizationTokenUnavailable, object: nil)
    }
}

// MARK: - Authenticator
extension Authenticator: Authentication {
    var isSignedIn: Bool {
        _mobileClient.isSignedIn
    }

    var userID: String? {
        _mobileClient.username
    }
    
    func initializeCognito(_ completion: @escaping (AuthState) -> Void) {
        _mobileClient.initialize { [weak self] (userState, error) in
            guard error == nil else { completion(.signedOut); return }
            if let userState = userState, userState == .signedIn {
                // First check if there is a userID. It is possible that the user deleted the app but Cognito cached the authorization token
                guard self?.userID != nil else { completion(.signedOut); return }
                // Check if the user has a shopID attached
                guard UserSession.shared.shopID != nil else { completion(.signedOut); return }

                // We are logged in if we pass both checks above
                completion(.signedIn)
            } else {
                completion(.signedOut)
            }
        }
    }

    func signIn(with credentials: Credentials, completion: AuthenticationResultHandler?) {
        _mobileClient.signIn(username: credentials.email, password: credentials.password) { (signInResult, error) in
            Authenticator.evaluateSignIn(with: signInResult, error: error, credentials: credentials) { [weak self] (result) in
                self?.authorizationToken { _ in
                    DispatchQueue.main.async {
                        if let completion = completion {
                            completion(result)
                        }
                    }
                }
            }
        }
    }

    func createAccount(with credentials: Credentials, completion: @escaping AuthenticationResultHandler) {
        _mobileClient.signUp(username: credentials.email, password: credentials.password, userAttributes: credentials.userAttributes ) { (signupResult, error) in
            Authenticator.evaluateCreateAccount(with: signupResult, error: error) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }

    func confirmSignup(with username: String, code: String, completion: @escaping AuthenticationResultHandler) {
        _mobileClient.confirmSignUp(username: username, confirmationCode: code) { (signUpResult, error) in
            Authenticator.evaluateCreateAccount(with: signUpResult, error: error) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }

    func confirmSignin(challengeResponse: String, completion: @escaping AuthenticationResultHandler) {
        _mobileClient.confirmSignIn(challengeResponse: challengeResponse) { (signinResult, error) in
            Authenticator.evaluateSignIn(with: signinResult, error: error) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }

    func requestForgotPasswordCode(for email: String, completion: @escaping (Result<PasswordRequestState, AuthenticationError>) -> Void) {
        _mobileClient.forgotPassword(username: email) { (result, error) in
            if let error = error as? AWSMobileClientError {
                CrashlyticsManager.recordError(
                    .forgotPasswordRequestError(description: error.localizedDescription, message: error.message),
                    error: error as NSError
                )
            }
            
            if let result = result, result.forgotPasswordState == .confirmationCodeSent {
                DispatchQueue.main.async { completion(.success(.sent(email))) }
            } else {
                DispatchQueue.main.async { completion(.failure(.passwordCodeRequestfailed)) }
            }
        }
    }

    func confirmForgotPasswordCode(for email: String, code: String, newPassword: String, completion: @escaping (Result<PasswordRequestState, AuthenticationError>) -> Void) {
        _mobileClient.confirmForgotPassword(username: email, newPassword: newPassword, confirmationCode: code) { (result, error) in
            if let value = result, value.forgotPasswordState == .done {
                DispatchQueue.main.async {
                    completion(.success(.confirmed))
                }
            } else {
                print("LOG ERROR confirmForgotPasswordCode ----> \(String(describing: error))")
                DispatchQueue.main.async {
                    completion(.failure(.passwordCodeRequestfailed))
                }
            }
        }
    }

    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Bool) -> Void) {
        _mobileClient.changePassword(currentPassword: currentPassword, proposedPassword: newPassword) { (error) in
            let result = error == nil
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func signOut(_ shouldPostNotification: Bool = false) {
        _mobileClient.signOut { _ in
            guard shouldPostNotification else { return }
            UserSettings().resetDefaults()
            NotificationCenter.default.post(name: .DidLogOutSuccessfully, object: nil)
        }
    }
}

// MARK: Helper
extension Authenticator {
    func authorizationToken(completion: @escaping (String?) -> Void) {
        _mobileClient.getTokens { (token, error) in
            guard error == nil else { completion(nil); return }
            guard let idToken = token?.idToken?.tokenString else { completion(nil); return }
            completion(idToken)
        }
    }
}

// MARK: - fileprivate
fileprivate extension Authenticator {
    static func evaluateCreateAccount(with result: SignUpResult?, error: Error?, completion: @escaping AuthenticationResultHandler) {
        if let result = result {
            switch result.signUpConfirmationState {
            case .confirmed:
                completion(.success(.confirmed))
            case .unconfirmed:
                completion(.success(.unconfirmed))
            default:
                completion(.failure(.creationError(AuthorizerClientError.message(from: error))))
            }
        } else {
            completion(.failure(.creationError(AuthorizerClientError.message(from: error))))
        }
    }

    static func evaluateSignIn(with result: SignInResult?, error: Error?, credentials: Authenticator.Credentials? = nil, completion: @escaping AuthenticationResultHandler) {
        guard error == nil else { completion(.failure(.signInFailed("User does not exist."))); return }

        if let result = result {
            switch result.signInState {
            case .signedIn: completion(.success(.signedIn))
            case .newPasswordRequired: completion(.success(.newPassword(challengeResponse: credentials?.password ?? "")))
            default: completion(.success(.signedOut))
            }
        }
    }

    @objc func forceSignout() { signOut(true) }
}
