//
//  Date+Extensions.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

// MARK: - Chat messages Date extensions
extension Date {
    func isInSameDayOf(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func wasYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
}

extension Date {
    func getMessageFormattedDateString() -> String {
        var dateString = ""
        if self.isToday() {
            dateString = "Today"
        } else if self.wasYesterday() {
            dateString = "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            dateString = dateFormatter.string(from: self)
        }
        
        let timerFormatter = DateFormatter()
        timerFormatter.dateFormat = "h:mm a"
        let timeString = timerFormatter.string(from: self)
        return dateString + " at " + timeString
    }
}
