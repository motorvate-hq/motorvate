//
//  StringUtils.swift
//  Motorvate
//
//  Created by Emmanuel on 5/25/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

extension String {
    // The VIN is a 17-character string of letters and numbers without intervening
    // spaces or the letters Q (q), I (i), and O (o)
    func isValidVehicleIdentificationNumber() -> Bool {

        // Must be exactly 17 characters.
        guard self.count == 17 else {
            return false
        }

        let allowedChars = "ABCDEFGHJKLMNPRSTUVWXYZ1234567890"
        let characterSet = CharacterSet(charactersIn: allowedChars)
        guard rangeOfCharacter(from: characterSet.inverted) == nil else {
            return false
        }

        return true
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    func isValidPhone() -> Bool {
        let phoneRegex = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
}

extension String {
    func setFormat(with mask: String) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

// MARK: - Password validation extension
extension String {
    func hasSevenSymbols() -> Bool {
        return self.count > 7
    }
    
    func hasSpecialSymbol() -> Bool {
        return  self.range(of: ".*[-!&^%$#@()/]+.*", options: .regularExpression) != nil
    }
    
    func hasNumber() -> Bool {
        return self.range(of: ".*[0-9]+.*", options: .regularExpression) != nil
    }
    
    func hasUppercaseSymbol() -> Bool {
        return self.range(of: ".*[A-Z]+.*", options: .regularExpression) != nil
    }
    
    func hasLowercaseSymbol() -> Bool {
        return self.range(of: ".*[a-z]+.*", options: .regularExpression) != nil
    }
    
    func isValidPassword() -> Bool {
        return self.hasSevenSymbols() && self.hasSpecialSymbol()
            && self.hasNumber() && self.hasUppercaseSymbol() && self.hasLowercaseSymbol()
    }
}
