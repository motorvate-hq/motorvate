//
//  ContactInformationFormView.swift
//  Motorvate
//
//  Created by Charlie on 2019-08-24.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

protocol ContactInformationViewDelegate: AnyObject {
    func didPressSendLinkButton(with phoneNumber: String)
}

final class ContactInformationView: UIView {
    fileprivate enum Constant {
        static let cornerRadius: CGFloat = 4.4
        static let sendLinkButtonSize: CGSize = CGSize(width: 180, height: 35)
    }

    var hasJob: Bool = false
    weak var delegate: ContactInformationViewDelegate?
    
    fileprivate let phoneRow = OnboardingFormRowView(labelText: "Phone", placeHolderText: "+1 333 555 8888", inputFormat: .phoneNumber, keyboardType: .phonePad)

    fileprivate let firstNameRow = OnboardingFormRowView(labelText: "First Name", placeHolderText: "John")
    fileprivate let lastNameRow = OnboardingFormRowView(labelText: "Last name", placeHolderText: "Smith")
    fileprivate let emailRow = OnboardingFormRowView(labelText: "Email", placeHolderText: "johnsmith@motorvate.me")

    fileprivate let sendLinkView: UIView = UIView()
    fileprivate let sendLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Link of this Form", for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 15)
        button.clipsToBounds = false
        button.layer.addShadow(
            backgroundColor: UIColor(red: 0.38, green: 0.235, blue: 0.733, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 6,
            shadowRadius: 10,
            shadowOffset: CGSize(width: 0, height: 4)
        )
        return button
    }()

    var viewModel: JobsViewModel?

    init(with viewModel: JobsViewModel, shouldShowSendFormButton: Bool) {
        self.viewModel = viewModel

        super.init(frame: .zero)
        setUI(shouldShowButton: shouldShowSendFormButton)
        if shouldShowSendFormButton {
            configureSendLinkView()
        }
        configure(with: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = Constant.cornerRadius
    }

    @objc func didPressSendLinkButton() {
        if let phone = phoneRow.textValue, phone.isValidPhone() {
            delegate?.didPressSendLinkButton(with: phone)
        }
    }
    
    private func configureSendLinkView() {
        sendLinkView.addSubview(sendLinkButton)
        sendLinkButton.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview()
            make.top.right.equalToSuperview()
            make.size.equalTo(Constant.sendLinkButtonSize)
        }
    }
}

extension ContactInformationView {
    func setUI(with footerText: String? = nil, shouldShowButton: Bool = false) {
        backgroundColor = .systemBackground

        let formView = FormView(title: "Contact Information", rows: [phoneRow, firstNameRow, lastNameRow, emailRow], footerText: footerText)
        if shouldShowButton {
            formView.insertItem(sendLinkView, at: 1)
            sendLinkButton.addTarget(self, action: #selector(didPressSendLinkButton), for: .touchUpInside)
        }
        formView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(formView)

        formView.fillSuperView()
    }

    func configure(with viewModel: JobsViewModel) {
        let info = viewModel.customerInfo
        phoneRow.setTextValue(value: info.customerPhone)
        lastNameRow.setTextValue(value: info.customerLastName)
        firstNameRow.setTextValue(value: info.customerFirstName)
        emailRow.setTextValue(value: info.customerEmail)
    }
}

// MARK: Revisit
extension ContactInformationView {
     func setData() {
         let lastName = lastNameRow.textValue
         let firstName = firstNameRow.textValue
         let email = emailRow.textValue?.replacingOccurrences(of: " ", with: "").lowercased()
         let phone = phoneRow.textValue
         
         viewModel?.setCustomerInfo(firstName, lastName, email, phone)
    }
}

class CustomerInfoMeta: Encodable {
    var customerPhone: String?
    var customerFirstName: String?
    var customerLastName: String?
    var customerEmail: String?
}

extension CustomerInfoMeta {
    var dictionary: [String: Any] {
        let json: [String: Any] = [
            "customerPhone": "\(customerPhone ?? "")",
            "customerFirstName": "\(customerFirstName ?? "")",
            "customerLastName": "\(customerLastName ?? "")",
            "customerEmail": "\(customerEmail ?? "")"
        ]
        return json
    }
}
