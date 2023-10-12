//
//  ServiceTextFieldView.swift
//  Motorvate
//
//  Created by Nikita Benin on 27.05.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

protocol ServiceTextFieldViewDelegate: AnyObject {
    func textFieldEditingChanged(tag: Int, value: String?)
    func textFieldDidBeginEditing()
}

class ServiceTextFieldView: UIView {
    
    enum ServiceTextFieldViewMode {
        case text
        case currency
    }
    
    // MARK: - UI Elements
    private let frameView: UIView = {
        let view = UIView()
        view.layer.addShadow(
            backgroundColor: UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.09),
            cornerRadius: 4,
            shadowRadius: 6,
            shadowOffset: CGSize(width: 0, height: 1)
        )
        return view
    }()
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.medium, ofSize: 13)
        label.textColor = UIColor(red: 0.543, green: 0.543, blue: 0.543, alpha: 1)
        return label
    }()
    private let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    // MARK: - Variables
    weak var delegate: ServiceTextFieldViewDelegate?
    var mode: ServiceTextFieldViewMode = .text {
        didSet {
            switch mode {
            case .text:     textField.keyboardType = .default
            case .currency: textField.keyboardType = .decimalPad
            }
        }
    }
    private var currencySymbol: String = "$"
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setTextValue(value: String?) {
        if let value = value {
            textField.text = value
        }
    }
    
    func setPriceValue(value: Double?) {
        if let value = value {
            textField.text = String(format: "\(currencySymbol)%.2f", value)
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        addSubview(frameView)
        addSubview(coverView)
        coverView.addSubview(titleLabel)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        addSubview(textField)
    }
    
    @objc func textFieldEditingChanged() {
        switch mode {
        case .text:
            delegate?.textFieldEditingChanged(tag: tag, value: textField.text)
        case .currency:
            delegate?.textFieldEditingChanged(tag: tag, value: textField.text?.replacingOccurrences(of: currencySymbol, with: ""))
        }
    }
    
    private func setupConstraints() {
        snp.makeConstraints { (make) -> Void in
            make.height.equalTo(64)
        }
        frameView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(7)
            make.left.equalToSuperview().offset(7)
            make.right.equalToSuperview().inset(7)
            make.bottom.equalToSuperview().inset(7)
        }
        coverView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(28)
            make.height.equalTo(14)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(6)
            make.right.equalToSuperview().inset(6)
        }
        textField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(frameView.snp.top).offset(15)
            make.left.equalToSuperview().offset(31)
            make.right.equalToSuperview().inset(31)
            make.bottom.equalTo(frameView.snp.bottom).inset(15)
        }
    }
}

extension ServiceTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text, mode == .currency else { return }
        if text == "" {
            textField.text = currencySymbol
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, mode == .currency else { return }
        if text == currencySymbol {
            textField.text = ""
        }
        
        if let doubleValue: Double = Double(text.replacingOccurrences(of: currencySymbol, with: "")) {
            textField.text = String(format: "\(currencySymbol)%.2f", doubleValue)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text, mode == .currency else { return true }
        
        if text.count == 1 && string == "" {
            return false
        }
        
        if string == "," {
            textField.text = text + "."
            return false
        }
        
        if text.split(separator: ".").count == 2
            && text.split(separator: ".")[1].count == 2
            && string != "" {
            return false
        }
        
        return true
    }
}
