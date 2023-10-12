//
//  UITextField+Extensions.swift
//  Motorvate
//
//  Created by Nikita Benin on 07.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

enum TextFieldInputFormat {
    case text
    case phoneNumber
    case date
    case price
}

// MARK: Extension phone number formatter
extension UITextField {
    func textValueForFormat(_ inputFormat: TextFieldInputFormat) -> String? {
        switch inputFormat {
        case .phoneNumber:
            return self.text?.replacingOccurrences(of: "+1", with: "").replacingOccurrences(of: " ", with: "")
        case .date:
            fatalError("UITextField.textValueForFormat doesn't support .date format textValue")
        default:
            return self.text?.trimmingCharacters(in: .whitespaces)
        }
    }
    
    func textFieldDidBeginEditing(inputFormat: TextFieldInputFormat) {
        if self.text == "" && inputFormat == .phoneNumber {
            self.text = "+1"
        }
    }
    
    func textFieldDidEndEditing(inputFormat: TextFieldInputFormat) {
        if inputFormat == .phoneNumber {
            if self.text == "+1" {
                self.text = ""
            }
        }
    }
    
    func textFieldShouldChangeCharactersIn(range: NSRange, inputFormat: TextFieldInputFormat, replacementString: String) -> Bool {
        if inputFormat == .phoneNumber {
            if range.length == 1 && range.location == 1 {
                return false
            }
            
            guard let text = self.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: replacementString)
            self.text = newString.setFormat(with: "+X XXX XXX XXXX")
            return false
        }
        return true
    }
}
