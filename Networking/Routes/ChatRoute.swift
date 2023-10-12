//
//  ChatRoute.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-04-19.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

enum ChatRoute {
    case getHistories(shopId: String)
    case getHistory(shopID: String, customerID: String)
    case sendMessage(shopID: String, customerID: String, params: Parameters)
    case newPhoneNumber
    case updateReadStatus(request: UpdateReadStatusRequest)
}

extension ChatRoute: EndPointType {
    static let endpoint = "notifications"
    var path: String {
        switch self {
        case .getHistories(let shopId):
            return "\(ChatRoute.endpoint)/\(shopId)"
        case .getHistory(let shopID, let customerID):
            return "\(ChatRoute.endpoint)/\(shopID)/\(customerID)"
        case .sendMessage(let shopID, let customerID, _):
            return "\(ChatRoute.endpoint)/\(shopID)/\(customerID)"
        case .newPhoneNumber:
            return "\(ChatRoute.endpoint)/newPhoneNumber"
        case .updateReadStatus:
            return "\(ChatRoute.endpoint)/updatereadstatus"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getHistories,
             .getHistory,
             .newPhoneNumber:
            return .get
        case .sendMessage:
            return .put
        case .updateReadStatus:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .getHistories,
             .getHistory,
             .newPhoneNumber:
            return .request
        case .sendMessage(_, _, let params):
            return .requestParameters(bodyParameters: params, urlParameters: nil)
        case .updateReadStatus(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        }
    }
}
