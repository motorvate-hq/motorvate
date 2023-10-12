//
//  InquiryListDataSource.swift
//  Motorvate
//
//  Created by Nikita Benin on 03.05.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class InquiryListDataSource: UITableViewDiffableDataSource<InquiryListSectionItem, Inquiry> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
