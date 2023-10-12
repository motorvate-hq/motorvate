//
//  JobRoute.swift
//  Motorvate
//
//  Created by Emmanuel on 2/9/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

enum JobRoute {
    case getJob(jobID: String)
    case allJobs(parameters: Parameters)
    case createJob(parameters: Parameters)
    case updateJob(jobID: String, parameters: Parameters)
    case scanVin(jobID: String, parameters: Parameters)
    case getUploadURL(jobID: String, parameters: Parameters)
    
    case addUpdateJobDetails(parameters: Parameters)
    case deleteJobDetails(parameters: Parameters)
    
    case generateJobDetailsToken(parameters: Parameters)
    case getPaymentInvoicePreviewLink(request: PaymentInvoicePreviewLinkRequest)
    
    case addUpdateInquiryDetails(parameters: Parameters)
    case deleteInquiryDetails(parameters: Parameters)
    case sendEstimationLink(request: SendEstimationLinkRequest)
    case getEstimationPreviewLink(request: GetEstimationPreviewLinkRequest)
    
    case getScheduledService(parameters: Parameters)
}

extension JobRoute: EndPointType {
    static let endpoint = "jobs"
    var path: String {
        switch self {
        case .allJobs, .createJob:
            return JobRoute.endpoint
        case .getJob(let jobID):
            return "\(JobRoute.endpoint)/\(jobID)"
        case .getUploadURL(let jobID, _):
            return "\(JobRoute.endpoint)/\(jobID)/getUploadUrl"
        case .scanVin(let jobID, _):
            return "\(JobRoute.endpoint)/\(jobID)/scanvin"
        case .updateJob(let jobID, _):
            return "\(JobRoute.endpoint)/\(jobID)/status"
        case .addUpdateJobDetails, .deleteJobDetails:
            return "\(JobRoute.endpoint)/jobdetails"
        case .generateJobDetailsToken, .getPaymentInvoicePreviewLink:
            return "\(JobRoute.endpoint)/invoicedetailstoken"
        case .addUpdateInquiryDetails, .deleteInquiryDetails:
            return "\(JobRoute.endpoint)/inquiry_details"
        case .sendEstimationLink, .getEstimationPreviewLink:
            return "\(JobRoute.endpoint)/estimation_link"
        case .getScheduledService:
            return "\(JobRoute.endpoint)/scheduled_service"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .allJobs, .getJob, .getUploadURL, .getScheduledService:
            return .get
        case .createJob, .addUpdateJobDetails, .generateJobDetailsToken, .getPaymentInvoicePreviewLink, .addUpdateInquiryDetails, .sendEstimationLink, .getEstimationPreviewLink:
            return .post
        case .updateJob, .scanVin:
            return .patch
        case .deleteJobDetails, .deleteInquiryDetails:
            return .delete
        }
    }

    var task: HTTPTask {
        switch self {
        case .allJobs(let parameters), .getUploadURL(_, let parameters):
            return .requestParameters(bodyParameters: nil, urlParameters: parameters)
        case .getJob:
            return .request
        case .updateJob(_, let parameters),
             .scanVin(_, let parameters),
             .createJob(let parameters),
             .addUpdateJobDetails(let parameters),
             .deleteJobDetails(let parameters),
             .generateJobDetailsToken(let parameters),
             .addUpdateInquiryDetails(let parameters),
             .deleteInquiryDetails(let parameters):
            return .requestParameters(bodyParameters: parameters, urlParameters: nil)
        case .sendEstimationLink(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .getEstimationPreviewLink(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .getPaymentInvoicePreviewLink(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        case .getScheduledService(let parameters):
            return .requestParameters(bodyParameters: nil, urlParameters: parameters)
        }
    }
}
