//
//  CustomerRoute.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-06-01.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

enum CustomerRoute {
    case getCustomerList(urlParams: Parameters)
    case getCustomer(withId: String)
}

extension CustomerRoute: EndPointType {
    static let endpoint = "customers"
    var path: String {
        switch self {
        case .getCustomerList:
            return "\(CustomerRoute.endpoint)/list"
        case .getCustomer(let customerId):
            return "\(CustomerRoute.endpoint)/\(customerId)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getCustomerList, .getCustomer:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .getCustomerList(let urlParams):
            return .requestParameters(bodyParameters: nil, urlParameters: urlParams )
        case .getCustomer:
            return .request
        }
    }
}
