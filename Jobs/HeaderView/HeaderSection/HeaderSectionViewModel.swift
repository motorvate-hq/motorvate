//
//  HeaderSectionViewModel.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-01-31.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

struct HeaderSectionViewModel {
    enum Section {
        case newInquiry, newDropOff, startOnboard
    }

    let section: Section

    var title: String {
        switch section {
        case .newInquiry:
            return "Send Forms"
        case .newDropOff:
            return "New Service"
        case .startOnboard:
            return "OnBoard Vehicle"
        }
    }
}
