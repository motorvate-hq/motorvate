//
//  OnboardViewModel.swift
//  Motorvate
//
//  Created by Emmanuel on 8/14/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

typealias OnboardViewModelResponseHandler = (OnboardViewModelError?) -> Void

class OnboardViewModel {
    static let inquiryIdentifierKey = "inquiryIdentifierKey"

    enum FileMetadataType: String {
        case jpeg
        case png
        case pdf
    }

    struct FileMetadata {
        let jobID: String
        let fileName: String
        let data: Data?
        let type: FileMetadataType
    }

    struct File: Codable {
        let filename: String
        let uploadUrl: URL
    }

    var vehicleIdentificationNumber: String?
    var shouldShowCustomerInquiryView: Bool = true
    var shouldShowJobsScreenOnCreateInquiry: Bool = true
    var requestMeta: JobRequestMeta
    fileprivate let service: JobService
    fileprivate let inquiryService: InquiryService
    fileprivate var inquiries: [Inquiry] = []
    var selectedIquiryID: String?
    var serviceDetail: [ServiceDetail]?

    init(_ service: JobService, requestMeta: JobRequestMeta, inquiryService: InquiryService = InquiryService()) {
        self.service = service
        self.requestMeta = requestMeta
        self.inquiryService = inquiryService
    }

    func createJob(for vehicleVin: String, completion: @escaping OnboardViewModelResponseHandler) {
        var requestParams = buildRequestParams()
        requestParams.vin = vehicleIdentificationNumber
                
        guard let shopId = UserSession.shared.shopID else {
            completion(.customError(message: "Shop ID is missing."))
            return
        }
        requestParams.shopID = shopId
        
        guard let userID = UserSession.shared.userID else {
            completion(.customError(message: "User ID is missing."))
            return
        }
        requestParams.userID = userID
        
        guard let jobType = requestMeta.serviceInfo.jobType, !jobType.isEmpty else {
            completion(.customError(message: "Job details field is required"))
            return
        }
        
        if let inquiryID = selectedIquiryID {
            requestParams.inquiryID = inquiryID
        }
        create(with: requestParams.dictionary ?? [String: Any](), completion: completion)
    }

    func getUploadURL(for metadata: OnboardViewModel.FileMetadata, completion: @escaping (Bool) -> Void) {
        completion(true)
//        service.getUploadURL(for: metadata) { (result) in
//            switch result {
//            case .success(let file):
//                print("success \(file)")
//            case .failure(let error):
//                print("Error \(error.localizedDescription)")
//            }
//        }
    }

    func getAllInquiries(for shopID: String, completion: @escaping () -> Void) {
        inquiryService.allInquiries(for: shopID) { (result) in
            switch result {
            case .success(let items):
                self.inquiries = items
            case .failure:
                self.inquiries = []
            }
            completion()
        }
    }

    func requiresJobType() -> Bool {
        requestMeta.serviceInfo.jobType == nil
    }

    func setServiceInfo(_ estimate: String?, _ jobType: String?) {
        let formattedEstimate = estimate?.replacingOccurrences(of: "$", with: "") ?? ""
        let estimateValue = Double(formattedEstimate)
        
        requestMeta.serviceInfo.jobType = jobType
        requestMeta.serviceInfo.estimate = estimateValue
    }

    func setIquiryIdentifier(_ identifier: String) {
        selectedIquiryID = identifier
    }
}

private extension OnboardViewModel {

    func buildRequestParams() -> CreateJobRequest {
        let request = CreateJobRequest(
            customerFirstName: requestMeta.customerInfo.customerFirstName,
            carModel: requestMeta.infoMeta.carModel,
            jobType: requestMeta.serviceInfo.jobType,
            service: requestMeta.infoMeta.service,
            customerPhone: requestMeta.customerInfo.customerPhone,
            customerEmail: requestMeta.customerInfo.customerEmail,
            quote: requestMeta.serviceInfo.estimate,
            customerLastName: requestMeta.customerInfo.customerLastName,
            note: requestMeta.infoMeta.note
        )
        return request
    }

    func create(with parameters: Parameters, completion: @escaping OnboardViewModelResponseHandler) {
        service.create(with: parameters) { (result) in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                switch error {
                case .invalidData:
                    completion(.invalidVIN)
                default:
                    completion(.requestFailed)
                }
            }
        }
    }

    func sendInquiryUpdateNotification(with identifier: String) {
        let inquiryIdentifierData: [String: String] = [OnboardViewModel.inquiryIdentifierKey: identifier]
        NotificationCenter.default.post(name: .InquiryClosedSuccessfully, object: nil, userInfo: inquiryIdentifierData)
    }
}

extension OnboardViewModel {
    var numberOfItems: Int {
        inquiries.count
    }

    func note(at indexPath: IndexPath) -> String {
         inquiries[indexPath.row].note
    }

    func item(at indexPath: IndexPath) -> Inquiry {
        inquiries[indexPath.row]
    }
    
    public var customers: [Customer] {
        let firstCustomer = Customer(customerID: nil, firstName: "John", lastName: "Smith", phoneNumber: "19173633549", email: "johnsmith@motorvate.com")
        let secondCustomer = Customer(customerID: nil, firstName: "Emmanuel", lastName: "Attoh", phoneNumber: "123456789", email: "emmanuelattoh@motorvate.com")
        let thirdCustomer = Customer(customerID: nil, firstName: "Sean", lastName: "Pana", phoneNumber: "2321234345", email: "seanpana@motorvate.com")
        let fourthCustomer = Customer(customerID: nil, firstName: "Emmanuel", lastName: "Asssjkd", phoneNumber: "3456789032", email: "emanuelasssjkd@motorvate.com")
        return [firstCustomer, secondCustomer, thirdCustomer, fourthCustomer]
    }

    func didSelectItem(at indexPath: IndexPath) {
        self.selectedIquiryID = inquiries[indexPath.row].id
    }
}

enum OnboardViewModelError: Error {
    case requestFailed
    case missingInquiryIdentifier
    case invalidVIN
    case customError(message: String)
}

extension OnboardViewModelError {
    var message: String {
        switch self {
        case .missingInquiryIdentifier:
            return "Inquiry is missing an identifier"
        case .requestFailed:
            return "Unable to complete request, please contact support if issue persist."
        case .invalidVIN:
            return "Invalid VIN."
        case .customError(let message):
            return message
        }

    }
}

extension Notification.Name {
    static let JobsViewControllerFetchAllJobs = Notification.Name("jobsViewControllerFetchAllJobs")
    static let InquiryClosedSuccessfully = Notification.Name("inquiryClosedSuccessfully")
}

// MARK: - License plate decoder
extension OnboardViewModel {
    func readLicensePlate(image: UIImage, completion: @escaping (PlateDecoderResponse?, ScanError?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        let service = PlateRecognizerService()
        let request = PlateReaderRequest(upload: imageData.base64EncodedString())
        service.plateReader(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                print("readLicensePlate response:", response)
                self?.decodeLicensePlate(plateReaderResponse: response, completion: completion)
            case .failure(let error):
                print("readLicensePlate error:", error)
                let scanError = ScanError.undableToScan
                completion(nil, scanError)
            }
        }
    }
    
    func decodeLicensePlate(plateReaderResponse: PlateReaderResponse, completion: @escaping (PlateDecoderResponse?, ScanError?) -> Void) {
        let service = CarsXEService()
        let request = PlateDecoderRequest(plateReaderResponse: plateReaderResponse)
        service.plateDecoder(request: request) { result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                print("decodeLicensePlate error:", error)
                let scanError = ScanError.noVinForScan
                completion(nil, scanError(plateReaderResponse.licensePlate))
            }
        }
    }
}
