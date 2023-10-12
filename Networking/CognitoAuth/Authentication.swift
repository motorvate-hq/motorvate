//
//  Authentication.swift
//  Motorvate
//
//  Created by Emmanuel on 9/22/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

typealias AuthenticationResultHandler = (Result<AuthState, AuthenticationError>) -> Void

protocol Authentication {
    var isSignedIn: Bool { get }
    var userID: String? { get }

    func initializeCognito(_ completion: @escaping (AuthState) -> Void)
    func signOut(_ shouldPostNotification: Bool)
    func signIn(with credentials: Authenticator.Credentials, completion: AuthenticationResultHandler?)
    func createAccount(with credentials: Authenticator.Credentials, completion: @escaping AuthenticationResultHandler)
    func confirmSignup(with username: String, code: String, completion: @escaping AuthenticationResultHandler)
    func confirmSignin(challengeResponse: String, completion: @escaping AuthenticationResultHandler)
    func requestForgotPasswordCode(for email: String, completion: @escaping (Result<PasswordRequestState, AuthenticationError>) -> Void)
    func confirmForgotPasswordCode(for email: String, code: String, newPassword: String, completion: @escaping (Result<PasswordRequestState, AuthenticationError>) -> Void)
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Bool) -> Void)
}

extension Authentication {
    func initializeCognito(_ completion: @escaping (AuthState) -> Void) {}
}
