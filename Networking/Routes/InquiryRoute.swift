//
//  InquiryRoute.swift
//  Motorvate
//
//  Created by Emmanuel on 5/2/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

enum InquiryRoute {
    case createInquiry(request: CreateInquiryRequest)
    case allInquiries(shopID: String)
    case sendFormLink(request: SendFormLinkRequest)
    case getFormInfo(request: GetFormInfoRequest)
    case delete(inquiryId: String)
}

extension InquiryRoute: EndPointType {
    var path: String {
        switch self {
        case .createInquiry, .allInquiries:
            return "jobs/inquiry"
        case .sendFormLink:
            return "jobs/token"
        case .getFormInfo:
            return "jobs/token"
        case .delete(let inquiryId):
            return "/jobs/inquiry/\(inquiryId)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .createInquiry, .sendFormLink, .getFormInfo:
            return .post
        case .allInquiries:
            return .get
        case .delete:
            return .delete
        }
    }

    var task: HTTPTask {
        switch self {
        case .allInquiries(let shopID):
            return .requestParameters(bodyParameters: nil, urlParameters: ["shopID": shopID])
        case .createInquiry(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .sendFormLink(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .getFormInfo(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .delete:
            return .request
        }
    }
}
