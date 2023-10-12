//
//  NewInquiryViewController.swift
//  Motorvate
//
//  Created by Bojan on 2.3.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import UIKit

final class NewInquiryViewController: UIViewController {
    private lazy var jobService: JobService = JobService()
    
    fileprivate enum Constants {
        static let title = "New Inquiry"
    }
    
    fileprivate let viewModel: JobsViewModel
    
    weak var coordinatorDelegate: JobsCoordinatorDelegate?
    private let stackScrollView = StackScrollView()
    private let contactInformationModule: ContactInformationView
    private let jobInformationModule: JobInformationView
    
    var currentInquiry: Inquiry?
    
    weak var newInquiryDelegate: NewInquiryDelegate?
    
    init(_ viewModel: JobsViewModel) {
        self.viewModel = viewModel
        self.contactInformationModule = ContactInformationView(with: viewModel, shouldShowSendFormButton: false)
        self.jobInformationModule = JobInformationView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCloseButton()
        hideLeftBarButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()
        //        dropOffTimeModule.setupInputDatePiker()
        hideKeyboardWhenTappedAround()
        registerNotifications()
    }
    
    @objc func didPressCloseButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        stackScrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc private func keyboardWillHide() {
        stackScrollView.contentInset = .zero
    }
    private func hideLeftBarButton() {
        navigationItem.setHidesBackButton(true, animated: false)
    }
}

fileprivate extension NewInquiryViewController {
    func setConstraints() {
        title = Constants.title
        view.backgroundColor = .systemGray6
        stackScrollView.keyboardDismissMode = .interactive
        view.addSubview(stackScrollView)
        
        NSLayoutConstraint.activate([
            stackScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            stackScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        stackScrollView.insertView(contactInformationModule)
        stackScrollView.insertView(jobInformationModule)
        stackScrollView.insertView(BaseSwiftUIView(rootView: ButtonView(title: "Save Inquiry", background: R.color.c1B34CE(), action: {
            self.didPressSaveInquiryButton()
        }).padding(.bottom, 15)))
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupCloseButton() {
        let backItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didPressCloseButton))
        navigationItem.rightBarButtonItem = backItem
    }
    
    func validateInputFields() -> Bool {
        setData()
        
        if
            viewModel.requestMeta.customerInfo.customerPhone?.isEmpty != false ||
            viewModel.requestMeta.customerInfo.customerLastName?.isEmpty != false ||
            viewModel.requestMeta.customerInfo.customerFirstName?.isEmpty != false ||
            viewModel.requestMeta.customerInfo.customerEmail?.isEmpty != false ||
            viewModel.requestMeta.infoMeta.carModel?.isEmpty != false ||
            viewModel.requestMeta.infoMeta.service?.isEmpty != false {
            BaseViewController.presentAlert(message: "Please complete customer and job information before selecting service", from: self)
            return false
        }
        
        guard viewModel.isValidPhoneNumber else {
            BaseViewController.presentAlert(message: "Input a valid customer phone. e.g: 1234567894", from: self)
            return false
        }
        
        guard viewModel.isFirstNameValid else {
            BaseViewController.presentAlert(message: "Input a valid first name. e.g: John", from: self)
            return false
        }
        
        guard viewModel.isLastNameValid else {
            BaseViewController.presentAlert(message: "Input a valid last name. e.g: Smith", from: self)
            return false
        }
        
        guard viewModel.isValidEmail else {
            BaseViewController.presentAlert(message: "Input a valid email. e.g: johnsmith@motorvate.me", from: self)
            return false
        }
        
        guard viewModel.isCarModelValid else {
            BaseViewController.presentAlert(message: "Input a valid card model. e.g: BMW X5 from 2009", from: self)
            return false
        }
        
        guard viewModel.isServiceValid else {
            BaseViewController.presentAlert(message: "Input a valid service. e.g: Vinly wrap", from: self)
            return false
        }
        
        return true
    }
}

extension NewInquiryViewController {
    func didPressSaveInquiryButton() {
        guard validateInputFields() else { return }

        setAsLoading(true)
        viewModel.saveAsInquiry { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setAsLoading(false)
            switch result {
            case .success:
                NotificationCenter.default.post(name: .RefetchInquiries, object: nil)

                self?.dismiss(animated: true, completion: {
                    self?.newInquiryDelegate?.showNewInquiryConfirmation()
                })
            case .failure:
                BaseViewController.presentAlert(message: "Unable to save inquiry.", from: strongSelf)
            }
        }
    }
    
    func setData() {
        contactInformationModule.setData()
        jobInformationModule.setData()
    }
}
