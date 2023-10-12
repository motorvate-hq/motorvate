//
//  StripeRoute.swift
//  Motorvate
//
//  Created by Nikita Benin on 12.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

enum StripeRoute {
    case hasConnectedStripe(request: HasConnectedStripeRequest)
    case createAccount(request: CreateStripeAccountRequest)
    case createAccountLink(request: CreateStripeAccountLinkRequest)
    case getStripeAccount(request: GetStripeAccountRequest)
    case getStripeLoginLink(request: GetStripeAccountRequest)
}
    
extension StripeRoute: EndPointType {
    static let endpoint = "stripe"
    var path: String {
        switch self {
        case .hasConnectedStripe:
            return "\(StripeRoute.endpoint)/has_connected_stripe"
        case .createAccount:
            return "\(StripeRoute.endpoint)/create_account"
        case .createAccountLink:
            return "\(StripeRoute.endpoint)/create_account_link"
        case .getStripeAccount:
            return "\(StripeRoute.endpoint)/get_stripe_account"
        case .getStripeLoginLink:
            return "\(StripeRoute.endpoint)/login_link"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .hasConnectedStripe, .createAccount, .createAccountLink, .getStripeAccount, .getStripeLoginLink:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .hasConnectedStripe(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .createAccount(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .createAccountLink(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .getStripeAccount(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .getStripeLoginLink(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        }
    }
}
