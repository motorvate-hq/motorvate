//
//  AppComponent.swift
//  Motorvate
//
//  Created by Emmanuel on 2/23/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

class AppComponent {
    static func makeSecuretextfield(with placeHolder: String) -> UITextField {
        let textField = makeFormTextField(.default, true)
        textField.placeholder = placeHolder
        return textField
    }

    static func textfield(with placeHolder: String) -> UITextField {
        let textField = makeFormTextField()
        textField.placeholder = placeHolder
        return textField
    }

    static func makeFormTextField(
        _ keyboardType: UIKeyboardType = .default,
        _ isSecure: Bool = false,
        inputFormat: TextFieldInputFormat = .text,
        textContentType: UITextContentType? = nil
    ) -> UITextField {
        let textfield = CustomTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.autocapitalizationType = .none
        textfield.isSecureTextEntry = isSecure == true
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = keyboardType
        textfield.inputFormat = inputFormat
        textfield.textContentType = textContentType
        return textfield
    }

    static func makeFormTextFieldHeaderLabel(with title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.semiBold, ofSize: 17)
        label.textColor = AppColor.textPrimary
        label.text = title
        return label
    }

    static func makeFormHeaderLabel(with title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.bold, ofSize: 19)
        label.textColor = UIColor(named: "headerTitle")
        label.text = title
        return label
    }

    static func makeTitleLabel(with title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.semiBold, ofSize: 14.3)
        label.text = title
        label.textColor = UIColor(named: "componentText")
        return label
    }
}
