//
//  JobsViewModel.swift
//  Motorvate
//
//  Created by Emmanuel on 8/2/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation
import UIKit

typealias JobAction = () -> Void

protocol JobsViewModelDatasource {
    func numberOfSections() -> Int
    func isLast(section: Int) -> Bool
    func item(at indexPath: IndexPath) -> Job
    func numberOfItems(in section: Int) -> Int
}

final class JobsViewModel {
    private let service: JobServiceProtocol
    private let inquiryService: InquiryServiceProviding
    private var sectionData: [SectionJobData] = []

    private var isFiltered: Bool = false
    private var filteredData: [SectionJobData] = []
    
    var filterJobStatus: Job.Status = .none

    private var selectedIndexPath: IndexPath?

    var reloadAction: JobAction?

    var section: [SectionJobData] {
        isFiltered ? filteredData : sections
    }

    let requestMeta: JobRequestMeta
    init(_ service: JobServiceProtocol, _ inquiryService: InquiryServiceProviding) {
        self.service = service
        self.inquiryService = inquiryService
        self.requestMeta = JobRequestMeta()
    }

    func fetchAllJobs() {
        guard let shopID = UserSession.shared.shopID else { return }
        service.allJobs(with: ["shopID": shopID]) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                JobDataStore.shared.insert(data, completion: { _ in
                    strongSelf.sectionData = strongSelf.makeSectionJobData(from: data)
                })
                strongSelf.filter(for: strongSelf.filterJobStatus)
            case .failure:
                break
            }

            self?.reload()
        }
    }

    func sendServiceAgreement(completion: @escaping (Bool) -> Void) {
        let deadlineTime = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            completion(true)
        }
    }

    func saveAsInquiry(completion: @escaping InquiryPersistingCompletion) {
        let request = CreateInquiryRequest(
            carModel: jobInfoMeta.carModel,
            customerEmail: customerInfo.customerEmail,
            customerFirstName: customerInfo.customerFirstName,
            customerLastName: customerInfo.customerLastName,
            customerPhone: "1\(customerInfo.customerPhone ?? "")",
            service: jobInfoMeta.service,
            shopID: UserSession.shared.shopID
        )
        inquiryService.createInquiry(with: request, completion: completion)
    }

    func update(jobID: String, with status: Job.Status) {
        updateWith(jobID: jobID, status: status)
    }

    func sendLinkInfo(with phoneNumber: String, isScheduleToken: Bool, completion: @escaping BooleanCompletion) {
        guard let shopID = UserSession.shared.shopID else { return }
        
        let request = SendFormLinkRequest(shopID: shopID, customerPhone: phoneNumber, isScheduleToken: isScheduleToken)
        inquiryService.sendFormLink(with: request, completion: completion)
    }
    
    func getFormInfo(with phoneNumber: String, isScheduleToken: Bool, completion: @escaping ((Result<FormInfo, NetworkResponse>) -> Void)) {
        guard let shopID = UserSession.shared.shopID else { return }
        
        let request = GetFormInfoRequest(shopID: shopID, customerPhone: phoneNumber, isScheduleToken: isScheduleToken)
        inquiryService.getFormInfo(with: request, completion: completion)
    }

    private func makeSectionJobData(from jobs: [Job]) -> [SectionJobData] {
        let filter: [Job.Status] = [.inProgress, .inqueue]

        guard !jobs.isEmpty else { return [] }

        var results: [SectionJobData] = []
        for status in filter {
            var section = SectionJobData(status: status, jobs: [])
            for job in jobs where job.status == status {
                section.jobs.append(job)
            }
            if !section.jobs.isEmpty {
                results.append(section)
            }
        }
        return results
    }
}

extension JobsViewModel {
    func isContantInfoValid() -> Bool {
        let info = requestMeta.customerInfo
        if let firtName = info.customerFirstName, let lastName = info.customerLastName, let email = info.customerEmail {
            return !firtName.isEmpty && !lastName.isEmpty && email.isValidEmail()
        }

        return false
    }
    
    func isJobInfoValid() -> Bool {
        let info = requestMeta.infoMeta
        if let carModel = info.carModel, let service = info.service {
            return !carModel.isEmpty && !service.isEmpty
        }

        return false
    }
    
    var isValidPhoneNumber: Bool {
        requestMeta.customerInfo.customerPhone?.isValidPhone() ?? false
    }
    
    var isValidEmail: Bool {
        requestMeta.customerInfo.customerEmail?.isValidEmail() ?? false
    }
    
    var isLastNameValid: Bool {
        guard let lastName = requestMeta.customerInfo.customerLastName else { return false }
        return !lastName.isEmpty
    }
    
    var isFirstNameValid: Bool {
        guard let firstName = requestMeta.customerInfo.customerFirstName else { return false }
        return !firstName.isEmpty
    }
    
    var isCarModelValid: Bool {
        guard let carModel = requestMeta.infoMeta.carModel else { return false }
        return !carModel.isEmpty
    }
    
    var isServiceValid: Bool {
        guard let service = requestMeta.infoMeta.service else { return false }
        return !service.isEmpty
    }
    
    var shouldShowSendLinkButton: Bool {
        requestMeta.customerInfo.customerPhone == nil
    }

    var customerInfo: CustomerInfoMeta {
        requestMeta.customerInfo
    }

    var jobInfoMeta: JobInfoMeta {
        requestMeta.infoMeta
    }

    var jobRequestMeta: JobRequestMeta {
        requestMeta
    }

    var inquiryParameters: Parameters {
        var params = requestMeta.infoMeta.dictionary
        let contactParams = requestMeta.customerInfo.dictionary
        params.merge(contactParams) { (_, new) in new }
        return params
    }

//    func setDropoffInfo(_ date: String?, _ slot: String?) {
//        requestMeta.dropOffInfo.date = date
//        requestMeta.dropOffInfo.slot = slot
//    }

    func setJobInfo(_ carModel: String?, _ notes: String?, _ service: String?) {
        requestMeta.infoMeta.carModel = carModel
        requestMeta.infoMeta.note = notes
        requestMeta.infoMeta.service = service
    }

    func setCustomerInfo(_ firstName: String?, _ lastName: String?, _ email: String?, _ phone: String?) {
        requestMeta.customerInfo.customerFirstName = firstName
        requestMeta.customerInfo.customerLastName = lastName
        requestMeta.customerInfo.customerEmail = email
        requestMeta.customerInfo.customerPhone = phone
    }

    func updateContext(for indexPath: IndexPath) -> (jobID: String, status: Job.Status) {
        selectedIndexPath = indexPath
        let jobItem = item(at: indexPath)
        return (jobItem.jobID, jobItem.status)
    }

    func filter(for status: Job.Status) {
        filterJobStatus = status
        if status == .none {
            isFiltered = false
            reload()
            return
        }
        isFiltered = true
        filteredData = sectionData
        filteredData = filteredData.filter { $0.status == status }
        reload()
    }
}

fileprivate extension JobsViewModel {
//    func createInquiry(_ params: Parameters, completion: @escaping BooleanCompletion) {
//        var userParam: Parameters = [
//            "shopID": UserSession.shared.shopID ?? "",
//            "userID": UserSession.shared.userID ?? ""
//        ]
//
//        userParam.merge(params) { (_, new) in new }
//        inquiryService.createInquiry(with: userParam, completion: completion)
//    }

    func updateWith(jobID: String, status: Job.Status) {
        let parameters: Parameters = ["status": status.value]
        service.update(jobID: jobID, parameters: parameters) { [weak self] (result) in
            switch result {
            case .success:
                AnalyticsManager.logJobStatusChange(status)
                self?.updateAtIndexPath()
            case .failure(let error):
                self?.reload()
                print("failed to update job with status error: \(error)")
            }
        }
    }
    
    func updateAtIndexPath() {
        guard let indexPath = selectedIndexPath else { return }
        // remove the job from its previous index
        if isFiltered {
            filteredData[indexPath.section].jobs.remove(at: indexPath.row)
        } else {
            sectionData[indexPath.section].jobs.remove(at: indexPath.row)
        }
        fetchAllJobs()
    }

    func reload() {
        if let action = reloadAction {
            action()
        }
    }
}

extension JobsViewModel: JobsViewModelDatasource {
    func isLast(section: Int) -> Bool {
        return sections.count == section
    }

    func item(at indexPath: IndexPath) -> Job {
        return sections[indexPath.section].jobs[indexPath.row]
    }

    func numberOfItems(in section: Int) -> Int {
        return sections[section].jobs.count
    }

    func numberOfSections() -> Int {
        return sections.count
    }

    private var sections: [SectionJobData] {
        return isFiltered ? filteredData : sectionData
    }
}

struct JobRequestMeta {
    var infoMeta: JobInfoMeta
    var customerInfo: CustomerInfoMeta
//    var dropOffInfo: DropOffInfoMeta
    var serviceInfo: ServiceInfoMeta

    init () {
        self.infoMeta = JobInfoMeta()
        self.customerInfo = CustomerInfoMeta()
//        self.dropOffInfo = DropOffInfoMeta()
        self.serviceInfo = ServiceInfoMeta()
    }
}
