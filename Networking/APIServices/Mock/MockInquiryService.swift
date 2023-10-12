//
//  MockInquiryService.swift
//  Motorvate
//
//  Created by Emmanuel on 8/15/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

struct MockInquiryService: InquiryServiceProviding {
    
    enum Identifier {
        static let valid = "F437D954-ECED-40CB-9813-6EAC644812C5"
        static let invalid = "CC769D2A-FA54-42CB-95AB-4258B06F9B25"
    }

    enum ShopIdentifier {
        static let valid = "3A37A3B3-8F6E-4F31-BDFD-4CAA39B66131"
    }
    
    func createInquiry(with request: CreateInquiryRequest, completion: @escaping InquiryPersistingCompletion) {
        
    }

    func allInquiries(for shopID: String, completion: @escaping (Result<[Inquiry], NetworkResponse>) -> Void) {
        var inquiryList = [Inquiry]()
        for inquiry in makeInquiryList() where inquiry.shopID == shopID {
            inquiryList.append(inquiry)
        }

        completion(.success(inquiryList))
    }

    func update(specifiedBy identifier: String, parameters: Parameters, completion: @escaping (Result<Inquiry, NetworkResponse>) -> Void) {

    }
    
    func sendFormLink(with request: SendFormLinkRequest, completion: @escaping BooleanCompletion) {
        
    }
    
    func getFormInfo(with request: GetFormInfoRequest, completion: @escaping ((Result<FormInfo, NetworkResponse>) -> Void)) {
        
    }
    
    func deleteInquiry(with inquiryId: String, completion: @escaping BooleanCompletion) {
        
    }
}

private extension MockInquiryService {
    func makeInquiryList() -> [Inquiry] {
        let inquiry1 = Inquiry(id: Identifier.valid, createdAt: nil, userID: "005B59F0-A552-4BB1-9EE3-FB01A3500FFD", shopID: ShopIdentifier.valid, model: "Audi", service: "cleaning", note: "Now", status: .open, customer: nil)
        let inquiry2 = Inquiry(id: Identifier.invalid, createdAt: nil, userID: "005B59F0-A552-4BB1-9EE3-FB01A3500FFD", shopID: ShopIdentifier.valid, model: "Audi", service: "cleaning", note: "Now", status: .open, customer: nil)

        return [inquiry1, inquiry2]
    }
}
