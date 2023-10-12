//
//  InquiryListSectionItem.swift
//  Motorvate
//
//  Created by Nikita Benin on 28.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

class InquiryListSectionItem: Hashable {
    let title: String
    var inquiriesList: [Inquiry]
    let dateCompleted: Date

    init(title: String, inquiriesList: [Inquiry], dateCompleted: Date) {
        self.title = title
        self.inquiriesList = inquiriesList
        self.dateCompleted = dateCompleted
    }

    // MARK: - Hashable
    var uid = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }

    static func == (lhs: InquiryListSectionItem, rhs: InquiryListSectionItem) -> Bool {
        lhs.title == rhs.title
    }
}
