//
//  BusinessInformationFooterView.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-07.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

protocol BusinessInformationFooterViewDelegate: AnyObject {
    func didPressNextButton(businessName: String?, businessAddress: String?)
}

private struct Constants {
    static let spacing: CGFloat = 7
    static let textFieldHeight: CGFloat = 43
    static let buttonSize: CGSize = CGSize(width: 82, height: 43)
}

final class BusinessInformationFooterView: UICollectionReusableView {
    
    // MARK: - UI Elements
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        return stackView
    }()
    private let businessNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Business Name:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private let businessNameTextField: UITextField = {
        let textField = AppComponent.makeFormTextField()
        return textField
    }()
    private let businessAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Business Address:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private let businessAddressTextField: UITextField = {
        let textField = AppComponent.makeFormTextField()
        return textField
    }()
    private let nextButton = AppButton(title: "Next")

    // MARK: - Variables
    weak var delegate: BusinessInformationFooterViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setView()
        setupConstraints()
    }

    // MARK: UI Setup
    private func setView() {
        vStackView.addArrangedSubview(businessNameLabel)
        vStackView.addArrangedSubview(businessNameTextField)
        vStackView.addArrangedSubview(businessAddressLabel)
        vStackView.addArrangedSubview(businessAddressTextField)
        vStackView.setCustomSpacing(24, after: businessNameTextField)
        addSubview(vStackView)
        
        nextButton.configure(as: .primary)
        nextButton.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
        addSubview(nextButton)
    }
    
    private func setupConstraints() {
        vStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview()
        }
        businessNameTextField.snp.makeConstraints { make -> Void in
            make.height.equalTo(Constants.textFieldHeight)
        }
        businessAddressTextField.snp.makeConstraints { make -> Void in
            make.height.equalTo(Constants.textFieldHeight)
        }
        nextButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(vStackView.snp.bottom).offset(Constants.spacing)
            make.size.equalTo(Constants.buttonSize)
            make.right.equalToSuperview()
        }
    }

    @objc private func onButtonPressed() {
        delegate?.didPressNextButton(businessName: businessNameTextField.text, businessAddress: businessAddressTextField.text)
        businessNameTextField.resignFirstResponder()
        businessAddressTextField.resignFirstResponder()
    }
}

// MARK: ReusableView
extension BusinessInformationFooterView: ReusableView {}
