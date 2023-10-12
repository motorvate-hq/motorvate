//
//  AllCustomersViewModel.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-11-28.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

protocol CustomersViewModelDatasource {
    func job(at indexPath: IndexPath) -> Job
    func headerViewModel(at index: Int) -> DateSectionHeaderFooterViewModel?
}

final class CustomersViewModel {

    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return formatter
    }

    var sectionList = [Job.CustomerSectionItem]()

    private let service: JobServiceProtocol

    init(_ service: JobServiceProtocol) {
        self.service = service
    }
    
    func listCompletedJobs(completion: @escaping ([Job.CustomerSectionItem]) -> Void) {
        if let jobList = JobDataStore.shared.fetchJobList(), !jobList.isEmpty {
            let list = jobList.filter { $0.status == .completed }
            sectionList = makeCustomerSectionData(from: list)
            completion(sectionList)
            return
        }

        guard let shopID = UserSession.shared.shopID else { return }
        service.allJobs(with: ["shopID": shopID]) { [weak self] (result) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let sectionList = self.makeCustomerSectionData(from: data)
                    completion(sectionList)
                case .failure:
                    completion([])
                }
            }
        }
    }

    private func makeCustomerSectionData(from list: [Job]) -> [Job.CustomerSectionItem] {
        guard !list.isEmpty else { return [] }

        var results: [Job.CustomerSectionItem] = []
        for job in list {
            guard let dateComleted = job.milestones?.complete?.date else { continue }
            let sectionTitle = getSectionTitle(from: dateComleted)

            if let item = results.first(where: { $0.title == sectionTitle }) {
                item.jobList.append(job)
            } else {
                let sectionItem = Job.CustomerSectionItem(title: sectionTitle, jobList: [job], dateCompleted: dateComleted)
                results.append(sectionItem)
            }
        }

        results.sort { $0.dateCompleted > $1.dateCompleted }
        
        return results
    }

    private func getSectionTitle(from dateComleted: Date) -> String {
        if Calendar.current.isDateInYesterday(dateComleted) {
            return "Yesterday"
        } else {
            return Self.dateFormatter.string(from: dateComleted)
        }
    }
}

extension CustomersViewModel: CustomersViewModelDatasource {
    public func headerViewModel(at index: Int) -> DateSectionHeaderFooterViewModel? {
        guard index >= 0, !sectionList.isEmpty else { return nil }
        let item = sectionList[index]

        return DateSectionHeaderFooterViewModel(date: item.dateCompleted)
    }

    public func job(at indexPath: IndexPath) -> Job {
        return sectionList[indexPath.section].jobList[indexPath.row]
    }
}

extension Job {
    class CustomerSectionItem: Hashable {
        let title: String
        var jobList: [Job]
        let dateCompleted: Date

        var numberOfItems: Int {
            jobList.count
        }

        init(title: String, jobList: [Job], dateCompleted: Date) {
            self.title = title
            self.jobList = jobList
            self.dateCompleted = dateCompleted
        }

        // MARK: - Hashable
        var uid = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(uid)
        }

        static func == (lhs: CustomerSectionItem, rhs: CustomerSectionItem) -> Bool {
            lhs.title == rhs.title
        }
    }
}
