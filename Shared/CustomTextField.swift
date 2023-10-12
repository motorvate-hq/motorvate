//
//  CustomTextField.swift
//  Motorvate
//
//  Created by Emmanuel on 11/30/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    var inputFormat: TextFieldInputFormat = .text {
        didSet {
            if inputFormat == .phoneNumber {
                placeholder = "+1 333 555 8888"
                delegate = self
            }
        }
    }
    
    var textValue: String? {
        return self.textValueForFormat(inputFormat)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        styleLayer()
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    fileprivate func styleLayer() {
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.borderWidth = 1
        layer.cornerRadius = 4.4
        layer.borderColor = UIColor.systemGray5.cgColor

        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowColor = UIColor.systemGray5.cgColor
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.textFieldShouldChangeCharactersIn(range: range, inputFormat: inputFormat, replacementString: string)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textFieldDidBeginEditing(inputFormat: inputFormat)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.textFieldDidEndEditing(inputFormat: inputFormat)
    }
}
