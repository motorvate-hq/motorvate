//
//  JobDetailsViewModel.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-12-01.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

final class JobDetailsViewModel: DetailsViewModel {
    
    // MARK: - Variables
    var isLoading: Box<Bool> = .init(false)
    private var job: Job?
    private var service = JobService()
    private let depositFeeType: DepositFeeType
    
    // MARK: - Lifecycle
    init(job: Job, depositFeeType: DepositFeeType) {
        self.job = job
        self.depositFeeType = depositFeeType
    }
    
    var title: String {
        return "Job Details"
    }

    var phoneNumberText: String {
        return job?.contactInfo?.phone ?? ""
    }

    var emailText: String {
        return job?.contactInfo?.email ?? ""
    }

    var noteText: String {
        return job?.composedNote() ?? ""
    }

    var customerFullNameText: String {
        return "\(job?.contactInfo?.firstName ?? "") \(job?.contactInfo?.lastName ?? "")"
    }

    var vehicleInfoText: String {
        let description = job?.vehicle?.description ?? ""
        let vin = job?.vehicle?.vin ?? ""
        return "\(description)\n\n\(vin)"
    }

    var jobTypeText: String {
        return job?.jobType ?? ""
    }
    
    var serviceDetails: [ServiceDetail] {
        get { return job?.jobDetails ?? [] }
        set { job?.jobDetails = newValue }
    }
    
    var jobId: String {
        return job?.jobID ?? ""
    }

    var shouldShowEditButton: Bool {
        return job?.status != .completed
    }
    
    var sumLabelTitle: String {
        return "Total"
    }
    
    var descriptionText: String {
        return "Send invoice to customer by tapping Payment+Invoice in Messages. Customer will receive text to complete total payment and email for receipt."
    }
    
    private var depositPrice: Double {
        return serviceDetails.map({ Double($0.price ?? 0) }).reduce(0, +)
    }
    
    var estimatePrice: Double {
        var estimatePrice = 0.0
        let expectedTotal = PriceCalculator.calculateExpectedTotalPrice(price: depositPrice, includeFee: depositFeeType == .include)
        let fee = PriceCalculator.calculateFeeForPrice(price: depositPrice, includeFee: depositFeeType == .include)
        estimatePrice = max(expectedTotal - fee, 0)
        serviceDetails.forEach({
            estimatePrice += ($0.price ?? 0)
        })
        return estimatePrice
    }
    
    var customerPrice: Double {
        return PriceCalculator.calculateExpectedTotalPrice(price: depositPrice, includeFee: depositFeeType == .include)
    }
    
    var feePrice: Double {
        return PriceCalculator.calculateFeeForPrice(price: depositPrice, includeFee: depositFeeType == .include)
    }
    
    var inquiryPaidDetail: InquiryPaidDetail? {
        return job?.inquiryPaidDetail
    }
}

// MARK: - Internal API
extension JobDetailsViewModel {
    func addUpdateService(item: ServiceDetail, completion: @escaping (Result<[ServiceDetail], Error>) -> Void) {
        let request = AddUpdateJobDetailsRequest(jobID: jobId, jobDetail: item)
        isLoading.value = true
        service.addUpdateJobDetails(request: request) { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let job):
                if let serviceDetails = job.jobDetails {
                    completion(.success(serviceDetails))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteService(item: ServiceDetail, completion: @escaping (Result<[ServiceDetail], Error>) -> Void) {
        guard let detailID = item.id else { return }
        let request = DeleteJobDetailsRequest(jobID: jobId, detailID: detailID)
        
        isLoading.value = true
        service.deleteJobDetails(request: request, completion: { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let job):
                if let serviceDetails = job.jobDetails {
                    AnalyticsManager.logEvent(.jobServiceDeleted(price: item.price))
                    completion(.success(serviceDetails))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func handleGetPreviewLink(completion: @escaping ((Result<String, Error>) -> Void)) {
        guard let shop = UserSession.shared.shop,
              let job = job else { return }
        let request = PaymentInvoicePreviewLinkRequest(
            shopID: shop.id,
            customerPhone: String(job.contactInfo?.phone?.dropFirst() ?? ""),
            jobID: job.jobID,
            customerID: job.customerID ?? "",
            topicArn: shop.topicArn,
            feeFromShop: depositFeeType == .include
        )
        service.getPaymentInvoicePreviewLink(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
