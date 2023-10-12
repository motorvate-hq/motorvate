//
//  DateFormatter+Extensions.swift
//  Motorvate
//
//  Created by Nikita Benin on 28.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

extension DateFormatter {
    func decodeServerDate(from: String) -> Date {
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        return self.date(from: from) ?? Date.distantPast
    }
}
