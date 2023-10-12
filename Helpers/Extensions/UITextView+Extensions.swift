//
//  UITextView+Extensions.swift
//  Motorvate
//
//  Created by Motorvate on 10.3.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import UIKit

extension UITextView {
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
    
    func textViewDidBeginEditing(inputFormat: TextFieldInputFormat) {
        if self.text == "" && inputFormat == .phoneNumber {
            self.text = "+1"
        }
    }
    
    func textViewDidEndEditing(inputFormat: TextFieldInputFormat) {
        if inputFormat == .phoneNumber {
            if self.text == "+1" {
                self.text = ""
            }
        }
    }
    
    func textViewShouldChangeCharactersIn(range: NSRange, inputFormat: TextFieldInputFormat, replacementString: String) -> Bool {
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
