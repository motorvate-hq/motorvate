//
//  PasswordValidationView.swift
//  Motorvate
//
//  Created by Nikita Benin on 13.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class PasswordValidationView: UIStackView {
    
    // MARK: Variables
    private var hasCharacters: Box<Bool> = Box<Bool>(false)
    private var hasUpperCase: Box<Bool> = Box<Bool>(false)
    private var hasSymbol: Box<Bool> = Box<Bool>(false)
    
    // MARK: UI Elements
    private let charactersValidationView = ValidationLabelView()
    private let uppercaseValidationView = ValidationLabelView()
    private let symbolValidationView = ValidationLabelView()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateValidationStatus(hasCharacters: Bool, hasUpperCase: Bool, hasSymbol: Bool) {
        self.hasCharacters.value = hasCharacters
        self.hasUpperCase.value = hasUpperCase
        self.hasSymbol.value = hasSymbol
    }
    
    // MARK: UI Setup
    private func setView() {
        axis = .vertical
        
        charactersValidationView.setState(text: "At least 8 characters", isValid: hasCharacters)
        addArrangedSubview(charactersValidationView)
        
        uppercaseValidationView.setState(text: "Must contain an uppercase and lowercase letter", isValid: hasUpperCase)
        addArrangedSubview(uppercaseValidationView)
        
        symbolValidationView.setState(text: "Contains a symbol and number", isValid: hasSymbol)
        addArrangedSubview(symbolValidationView)
        
        spacing = 13
    }
}
