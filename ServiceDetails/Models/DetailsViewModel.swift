//
//  DetailsViewModel.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

protocol DetailsViewModel {
    
    var isLoading: Box<Bool> { get set }
    
    var title: String { get }
    var phoneNumberText: String { get }
    var emailText: String { get }
    var noteText: String { get }
    var customerFullNameText: String { get }
    var vehicleInfoText: String { get }
    var jobTypeText: String { get }
    var serviceDetails: [ServiceDetail] { get set }
    var jobId: String { get }
    var shouldShowEditButton: Bool { get }
    
    var sumLabelTitle: String { get }
    var descriptionText: String { get }
    
    func addUpdateService(item: ServiceDetail, completion: @escaping (Result<[ServiceDetail], Error>) -> Void)
    func deleteService(item: ServiceDetail, completion: @escaping (Result<[ServiceDetail], Error>) -> Void)
    
    var estimatePrice: Double { get }
    var customerPrice: Double { get }
    var feePrice: Double { get }
    
    var inquiryPaidDetail: InquiryPaidDetail? { get }
    func handleGetPreviewLink(completion: @escaping ((Result<String, Error>) -> Void))
}
