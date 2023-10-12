//
//  InquiryViewModel.swift
//  Motorvate
//
//  Created by Emmanuel on 5/2/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

final class InquiryListViewModel {
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    fileprivate var sectionList = [InquiryListSectionItem]()
    fileprivate let service: InquiryServiceProviding

    init(service: InquiryServiceProviding = InquiryService()) {
        self.service = service
    }

    func getAllInquiriesForShop(with shopID: String, completion: @escaping ([InquiryListSectionItem]) -> Void) {
        service.allInquiries(for: shopID) { [weak self] (result) in
            switch result {
            case .success(let inquiries):
                guard let strongSelf = self else { return }
                strongSelf.sectionList = strongSelf.makeInquiriesSectionData(from: inquiries)
                completion(strongSelf.sectionList)
            case .failure:
                completion([])
            }
        }
    }
    
    func handleDeleteItem(at indexPath: IndexPath, completion: @escaping (Bool, [InquiryListSectionItem]) -> Void) -> [InquiryListSectionItem] {
        let item = item(at: indexPath)
        service.deleteInquiry(with: item.id) { [weak self] result in
            if !result {
                guard let strongSelf = self else { return }
                strongSelf.sectionList[indexPath.section].inquiriesList.insert(item, at: indexPath.item)
                completion(false, strongSelf.sectionList)
            }
        }
        sectionList[indexPath.section].inquiriesList.remove(at: indexPath.item)
        return sectionList
    }
    
    private func makeInquiriesSectionData(from list: [Inquiry]) -> [InquiryListSectionItem] {
        guard !list.isEmpty else { return [] }

        var results: [InquiryListSectionItem] = []
        for inquiry in list {
            let date = inquiry.createdAt ?? Date.distantPast
            let sectionTitle = getSectionTitle(from: date)

            if let item = results.first(where: { $0.title == sectionTitle }) {
                item.inquiriesList.append(inquiry)
            } else {
                let sectionItem = InquiryListSectionItem(title: sectionTitle, inquiriesList: [inquiry], dateCompleted: date)
                results.append(sectionItem)
            }
        }

        results.sort { $0.dateCompleted > $1.dateCompleted }
        return results
    }
}

extension InquiryListViewModel {
    var isEmpty: Bool {
        return sectionList.isEmpty
    }

    func item(at indexPath: IndexPath) -> Inquiry {
        return sectionList[indexPath.section].inquiriesList[indexPath.row]
    }

    func removeItem(specifiedBy identifier: String) {
        for index in 0..<sectionList.count {
            sectionList[index].inquiriesList.removeAll(where: { $0.id == identifier })
        }
    }
}

extension InquiryListViewModel {
    func headerViewModel(at section: Int) -> DateSectionHeaderFooterViewModel? {
        guard section < sectionList.count else { return nil }
        let item = sectionList[section]
        return DateSectionHeaderFooterViewModel(date: item.dateCompleted)
    }

    private func getSectionTitle(from dateComleted: Date) -> String {
        if Calendar.current.isDateInYesterday(dateComleted) {
            return "Yesterday"
        } else if Calendar.current.isDateInToday(dateComleted) {
            return "Today"
        } else {
            return dateFormatter.string(from: dateComleted)
        }
    }
}
