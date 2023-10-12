//
//  DepositEstimatePopupViewModel.swift
//  Motorvate
//
//  Created by Nikita Benin on 25.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

class DepositEstimatePopupViewModel {
    
    // MARK: - Variables
    var serviceType: ServiceType
    var serviceId: String?
    let serviceDetails: [ServiceDetail]
    var depositEstimateType: DepositEstimateType
    var depositFeeType: DepositFeeType = .exclude
    var title: String {
        switch serviceType {
        case .job:      return "Payment + Invoice"
        case .inquiry(let excludingDeposit):  return excludingDeposit ? "Service Quote / Estimate" : "Deposit + Estimate"
        }
    }
    private let jobService = JobService()
    private var chatHistory: ChatHistory?
    var editButtonTitle: String {
        switch serviceType {
        case .job:      return "Edit"
        case .inquiry(let excludingDeposit):  return excludingDeposit ? "Edit Estimate" : "Edit"
        }
    }
    var sendButtonTitle: String {
        switch serviceType {
        case .job:      return "Send Payment / Invoice Link"
        case .inquiry(let excludingDeposit):  return excludingDeposit ? "Send Customer Quote / Estimate" : "Send Estimate / Deposit Link"
        }
    }
    var isEditingEnabled: Bool = true
    var isExcludingDeposit: Bool {
        return serviceType.isExcludingDeposit
    }
    
    // MARK: - Lifecycle
    init(inquiry: Inquiry, excludingDeposit: Bool) {
        self.serviceType = .inquiry(excludingDeposit: excludingDeposit)
        self.serviceId = inquiry.id
        self.depositEstimateType = excludingDeposit ? .none : .percent50
        self.serviceDetails = inquiry.inquiryDetails ?? []
    }
    
    init(job: Job, chatHistory: ChatHistory?) {
        self.serviceType = .job
        self.serviceId = job.jobID
        self.chatHistory = chatHistory
        self.serviceDetails = job.jobDetails ?? []
        self.depositEstimateType = .percent100
        self.isEditingEnabled = job.inquiryPaidDetail == nil
    }
    
    init(serviceDetails: [ServiceDetail], excludingDeposit: Bool) {
        self.serviceType = .inquiry(excludingDeposit: excludingDeposit)
        self.serviceDetails = serviceDetails
        self.depositEstimateType = .percent50
    }
    
    func handleGetPreviewLink(completion: @escaping ((Result<String, Error>) -> Void)) {
        switch serviceType {
        case .job:      return handleGetJobPreviewLink(completion: completion)
        case .inquiry:  return handleGetInquiryPreviewLink(completion: completion)
        }
    }
    
    private func handleGetInquiryPreviewLink(completion: @escaping ((Result<String, Error>) -> Void)) {
        guard let serviceId = serviceId else { return }
        let request = GetEstimationPreviewLinkRequest(
            inquiryID: serviceId,
            depositPercent: Int(depositEstimateType.percent),
            feeFromShop: depositFeeType == .include
        )
        jobService.getEstimationPreviewLink(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func handleGetJobPreviewLink(completion: @escaping ((Result<String, Error>) -> Void)) {
        guard let shop = UserSession.shared.shop,
              let customerPhone = chatHistory?.customer.phoneNumber?.dropFirst() else { return }
        let request = PaymentInvoicePreviewLinkRequest(
            shopID: shop.id,
            customerPhone: String(customerPhone),
            jobID: serviceId ?? "",
            customerID: chatHistory?.customer.customerID ?? "",
            topicArn: shop.topicArn,
            feeFromShop: depositFeeType == .include
        )
        jobService.getPaymentInvoicePreviewLink(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
