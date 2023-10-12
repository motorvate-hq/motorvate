//
//  UserRoute.swift
//  Motorvate
//
//  Created by Emmanuel on 2/24/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

enum UserRoute {
    case get(userID: String)
    case update(userID: String, params: Parameters)
    case deviceToken(userID: String, params: Parameters)
    case createShop(param: Parameters)
    case invite(param: Parameters)
    case getShop(shopID: String)
    case delete(userID: String)
    
    case createScheduledService(request: CreateScheduledServiceRequest)
}
    
extension UserRoute: EndPointType {
    static let endpoint = "users"
    var path: String {
        switch self {
        case .get(let userID), .update(let userID, _):
            return "\(UserRoute.endpoint)/\(userID)"
        case .deviceToken(let userID, _):
            return "\(UserRoute.endpoint)/token/\(userID)"
        case .createShop:
            return "\(UserRoute.endpoint)/shop"
        case .invite:
            return "\(UserRoute.endpoint)/invite"
        case .getShop(let shopID):
            return "\(UserRoute.endpoint)/shop/\(shopID)"
        case .delete(let userId):
            return "\(Self.endpoint)/\(userId)"
        case .createScheduledService:
            return "\(UserRoute.endpoint)/shop/createScheduledService"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .get, .getShop:
            return .get
        case .update, .deviceToken:
            return .put
        case .createShop, .invite, .createScheduledService:
            return .post
        case .delete:
            return .delete
        }
    }

    var task: HTTPTask {
        switch self {
        case .get, .getShop, .delete:
            return .request
        case .update(_, let params),
             .deviceToken(_, let params),
             .invite(let params),
             .createShop(let params):
            return .requestParameters(bodyParameters: params, urlParameters: nil)
        case .createScheduledService(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        }
    }
}
