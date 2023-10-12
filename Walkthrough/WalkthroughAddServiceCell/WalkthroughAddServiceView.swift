//
//  WalkthroughAddServiceView.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class WalkthroughAddServiceView: UIView {
    
    // MARK: UI Elements
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let descriptionTextField: ServiceTextFieldView = {
        let textField = ServiceTextFieldView()
        textField.setTitle(title: "Item Description (Labor, Part, Service, etc.)")
        textField.mode = .text
        textField.tag = 0
        return textField
    }()
    private let priceTextField: ServiceTextFieldView = {
        let textField = ServiceTextFieldView()
        textField.setTitle(title: "Item price")
        textField.mode = .currency
        textField.tag = 1
        return textField
    }()
    
    private var jobDetail = ServiceDetail(id: nil, description: nil, price: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getJobDetails() -> ServiceDetail? {
        if (jobDetail.description != nil) && (jobDetail.price != nil) {
            return jobDetail
        }
        return nil
    }
    
    private func setView() {
        backgroundColor = .white
        descriptionTextField.delegate = self
        stackView.addArrangedSubview(descriptionTextField)
        priceTextField.delegate = self
        stackView.addArrangedSubview(priceTextField)
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
}

// MARK: ServiceTextFieldViewDelegate
extension WalkthroughAddServiceView: ServiceTextFieldViewDelegate {
    func textFieldDidBeginEditing() { }
    
    func textFieldEditingChanged(tag: Int, value: String?) {
        guard let value = value else { return }
        switch tag {
        case 0: jobDetail.description = value
        case 1: jobDetail.price = Double(value)
        default:
            break
        }
    }
}
