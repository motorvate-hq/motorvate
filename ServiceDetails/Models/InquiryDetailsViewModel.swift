//
//  InquiryDetailsViewModel.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

final class InquiryDetailsViewModel: DetailsViewModel {
    
    // MARK: - Variables
    private var inquiry: Inquiry?
    var isLoading: Box<Bool> = .init(false)
    private var service = JobService()
    let depositPercent: Double
    let depositFeeType: DepositFeeType
    
    // MARK: - Lifecycle
    init(inquiry: Inquiry, depositPercent: Double, depositFeeType: DepositFeeType) {
        self.inquiry = inquiry
        self.depositPercent = depositPercent
        self.depositFeeType = depositFeeType
    }
    
    var title: String {
        return "Estimate Details"
    }
    
    var phoneNumberText: String {
        return inquiry?.customer?.phoneNumber ?? ""
    }

    var emailText: String {
        return inquiry?.customer?.email ?? ""
    }

    var noteText: String {
        return "Exact model will be confirmed during onboard through VIN number scan."
    }

    var customerFullNameText: String {
        return inquiry?.customer?.fullName ?? ""
    }

    var vehicleInfoText: String {
        return inquiry?.model ?? ""
    }

    var jobTypeText: String {
        return ""
    }
    
    var serviceDetails: [ServiceDetail] {
        get {
            return inquiry?.inquiryDetails ?? []
        }
        set {
            inquiry?.inquiryDetails = newValue
        }
    }
    
    var jobId: String {
        return inquiry?.id ?? ""
    }

    var shouldShowEditButton: Bool {
        return true
    }
    
    var sumLabelTitle: String {
        return "Estimate"
    }
    
    var descriptionText: String {
        return "Send estimates to customer/client by tapping Estimate+Deposit in Messages. Customer/Client will recieve text to pay deposit (optional) or confirm estimate above. 🚗💨"
    }
    
    private var depositPrice: Double {
        let totalPrice: Double = serviceDetails.map({ Double($0.price ?? 0) }).reduce(0, +)
        return totalPrice / 100 * Double(depositPercent)
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
        return nil
    }
}

// MARK: - Internal API
extension InquiryDetailsViewModel {
    func addUpdateService(item: ServiceDetail, completion: @escaping (Result<[ServiceDetail], Error>) -> Void) {
        let request = AddUpdateInquiryRequest(
            inquiryID: jobId,
            inquiryDetail: InquiryDetail(
                id: item.id,
                description: item.description,
                price: item.price,
                percent: depositPercent
            )
        )
                
        isLoading.value = true
        service.addUpdateInquiryDetails(request: request) { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let inquiry):
                if let serviceDetails = inquiry.inquiryDetails {
                    completion(.success(serviceDetails))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteService(item: ServiceDetail, completion: @escaping (Result<[ServiceDetail], Error>) -> Void) {
        guard let detailID = item.id else { return }
        let request = DeleteInquiryDetailsRequest(
            inquiryID: jobId,
            detailID: detailID
        )
                
        isLoading.value = true
        service.deleteInquiryDetails(request: request, completion: { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let inquiry):
                if let serviceDetails = inquiry.inquiryDetails {
                    AnalyticsManager.logEvent(.jobServiceDeleted(price: item.price))
                    completion(.success(serviceDetails))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func handleGetPreviewLink(completion: @escaping ((Result<String, Error>) -> Void)) {
        
    }
}
