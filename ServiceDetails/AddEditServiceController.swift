//
//  AddServiceController.swift
//  Motorvate
//
//  Created by Nikita Benin on 27.05.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

protocol AddEditServiceDelegate: AnyObject {
    func didAddUpdateService(jobDetail: ServiceDetail, isUpdate: Bool)
}

private struct Constants {
    static let safeArea = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.size.height - 60
    static let serviceTextFieldViewHeight: CGFloat = 64
    static let topOffset = (safeArea - serviceTextFieldViewHeight * 2) / 2 - 50
    static let addButtonSize: CGSize = CGSize(width: 95, height: 53)
}

class AddEditServiceController: UIViewController {

    // MARK: - UI Elements
    private let stackScrollView: StackScrollView = {
        let stackScrollView = StackScrollView()
        stackScrollView.backgroundColor = .clear
        stackScrollView.contentInset = UIEdgeInsets(top: Constants.topOffset, left: 0, bottom: 0, right: 0)
        return stackScrollView
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
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1), for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 16)
        button.backgroundColor = UIColor(red: 1, green: 0.683, blue: 0.076, alpha: 1)
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Variables
    private var jobDetail: ServiceDetail = ServiceDetail(id: nil, description: "", price: nil)
    weak var delegate: AddEditServiceDelegate?
    private var isUpdate = false
    private var textFieldIsEditing = false
    
    // MARK: - Lifecycle
    init(jobDetail: ServiceDetail?) {
        if let jobDetail = jobDetail {
            self.jobDetail = jobDetail
            self.isUpdate = true
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add service"
        setView()
        setupConstraints()
        
        registerNotifications()
        hideKeyboardWhenTappedAround()
    }
    
    @objc private func handleAdd() {
        guard let description = jobDetail.description,
              let price = jobDetail.price,
              !description.isEmpty,
              price != 0 else {
            BaseViewController.presentAlert(message: "All fields are required", from: self)
            return
        }
        
        delegate?.didAddUpdateService(jobDetail: jobDetail, isUpdate: isUpdate)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UI Setup
    private func setView() {
        view.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        view.addSubview(stackScrollView)
        
        descriptionTextField.setTextValue(value: jobDetail.description)
        descriptionTextField.delegate = self
        stackScrollView.insertView(descriptionTextField)
        
        priceTextField.setPriceValue(value: jobDetail.price)
        priceTextField.delegate = self
        stackScrollView.insertView(priceTextField)
        
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    private func setupConstraints() {
        stackScrollView.fillSuperView()
        addButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeArea.bottom).inset(30)
            make.right.equalToSuperview().inset(25)
            make.size.equalTo(Constants.addButtonSize)
        }
    }
}

// MARK: Keyboard notifications
extension AddEditServiceController {
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if textFieldIsEditing {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            stackScrollView.contentInset = UIEdgeInsets(top: Constants.topOffset - view.convert(keyboardFrame.cgRectValue, from: nil).size.height / 2, left: 0, bottom: 0, right: 0)
        }
    }

    @objc private func keyboardWillHide() {
        stackScrollView.contentInset = UIEdgeInsets(top: Constants.topOffset, left: 0, bottom: 0, right: 0)
    }
}

// MARK: ServiceTextFieldViewDelegate
extension AddEditServiceController: ServiceTextFieldViewDelegate {
    func textFieldDidBeginEditing() {
        textFieldIsEditing = true
    }
    
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
