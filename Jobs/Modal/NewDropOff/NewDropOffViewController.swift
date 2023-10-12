//
//  NewDropOffViewController.swift
//  Motorvate
//
//  Created by Charlie on 2019-08-24.
//  Copyright © 2019 motorvate. All rights reserved.
//

import SwiftUI
import UIKit

final class NewDropOffViewController: UIViewController {
    private lazy var jobService: JobService = JobService()

    fileprivate enum Constants {
        static let title = "New Service"
    }

    fileprivate let viewModel: JobsViewModel

    weak var coordinatorDelegate: JobsCoordinatorDelegate?
    private let stackScrollView = StackScrollView()
    private let contactInformationModule: ContactInformationView
    private let jobInformationModule: JobInformationView
    private let confirmStatusModule = ConfirmStatusView()
    
    var currentInquiry: Inquiry?
    
    init(_ viewModel: JobsViewModel) {
        self.viewModel = viewModel
        self.contactInformationModule = ContactInformationView(with: viewModel, shouldShowSendFormButton: false)
        self.jobInformationModule = JobInformationView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)

        confirmStatusModule.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCloseButton()
        hideLeftBarButton()
        
        contactInformationModule.configure(with: viewModel)
        jobInformationModule.configure(with: viewModel)
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

extension NewDropOffViewController {
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
        stackScrollView.insertView(BaseSwiftUIView(rootView: ServiceOptionsView(callback: { [weak self] index in
            guard let self = self else { return }
            
            switch index {
            case 1: self.didPressSaveInquiryButton()
            case 2: self.addScheduleServicePressed()
            case 3: self.didPressSendEstimateButton()
            case 4: self.didPressCreateButton()
            default: break
            }
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

extension NewDropOffViewController {
    func didPressCreateButton() {
        guard validateInputFields() else { return }
        
        AnalyticsManager.logEvent(.newDropOff)
        coordinatorDelegate?.showOnBoardingWith(params: viewModel.jobRequestMeta, shouldPush: false, shouldShowCustomerInquiryView: false, presenter: self)
    }
    
    func didPressSaveInquiryButton() {
        guard validateInputFields() else { return }

        let vc = NewInquiryViewController(viewModel)
        vc.newInquiryDelegate = self
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true)
    }
    
    func didPressSendEstimateButton() {
        guard validateInputFields() else { return }
        
        self.saveAsInquiryIfNeeded { [weak self] in
            guard let self = self else { return }
            guard let inquiry = self.currentInquiry else { return }
            
            let popupViewModel = DepositEstimatePopupViewModel(inquiry: inquiry, excludingDeposit: true)
            let vc = DepositEstimatePopupController(viewModel: popupViewModel, delegate: self)
            self.present(vc, animated: false)
        }
    }
    
    func saveAsInquiryIfNeeded(callback: @escaping (() -> Void)) {
        guard self.currentInquiry == nil else {
            callback()
            
            return
        }
        
        setAsLoading(true)
        viewModel.saveAsInquiry { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setAsLoading(false)
            switch result {
            case .success(let inquiry):
                NotificationCenter.default.post(name: .RefetchInquiries, object: nil)
                
                self?.currentInquiry = inquiry
                
                callback()
            case .failure:
                self?.presentAlert(title: "Error", message: "Unable to save inquiry.", handler: {
                    
                })
            }
        }
    }

    func setData() {
        contactInformationModule.setData()
        jobInformationModule.setData()
    }
}

// MARK: ConfirmStatusViewDelegate
extension NewDropOffViewController: ConfirmStatusViewDelegate {
    func didPressServiceAgreement() {
        guard viewModel.isValidPhoneNumber else {
            BaseViewController.presentAlert(message: "Input a valid customer phone. e.g: 1234567894", from: self)
            return
        }

        confirmStatusModule.isSent = true
        viewModel.sendServiceAgreement { (_) in
            self.confirmStatusModule.isSent = false
        }
    }
    
    private func presentInquiryDetails(type: DepositEstimateType, depositFeeType: DepositFeeType, excludingDeposit: Bool) {
        setData()
        
        guard let inquiry = self.currentInquiry else { return }
        
        let jobDetailsViewController = ServiceDetailsViewController(
            viewModel: InquiryDetailsViewModel(
                inquiry: inquiry,
                depositPercent: type.percent,
                depositFeeType: depositFeeType
            ), excludingDeposit: excludingDeposit
        )
        navigationController?.pushViewController(jobDetailsViewController, animated: true)
    }
}

extension NewDropOffViewController: DepositEstimatePopupControllerDelegate {
    func handleEditDetails(serviceType: ServiceType, type: DepositEstimateType, fee: DepositFeeType) {
        switch serviceType {
        case .job: break
        case .inquiry(let excludingDeposit):  presentInquiryDetails(type: type, depositFeeType: fee, excludingDeposit: excludingDeposit)
        }
    }
    
    func sendLink(serviceType: ServiceType, type: DepositEstimateType, fee: DepositFeeType) {
        guard let inquiry = self.currentInquiry else { return }
        
        let request = SendEstimationLinkRequest(
            inquiryID: inquiry.id,
            depositPercent: Int(type.percent),
            feeFromShop: fee == .include
        )
        setAsLoading(true)
        jobService.sendEstimationLink(request: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.setAsLoading(false)
                
                switch result {
                case .success(let _):
                    break// TODO: //111self?.configureFor(history: chatHistory)
                case .failure(let error):
                    CrashlyticsManager.recordError(.apiError(error: error as NSError), error: error as NSError)
                    self.presentAlert(title: "Error", message: error.localizedDescription, handler: {
                        
                    })
                }
            }
        }
    }
}

protocol NewInquiryDelegate: class {
    func showNewInquiryConfirmation()
}

extension NewDropOffViewController: NewInquiryDelegate {
    func showNewInquiryConfirmation() {
        var slideUpViewController: SlideUpViewController? = nil
        let vc = UIHostingController(rootView: AnyView(NewInquiryConfirmationView(callback: { [weak self] index in
            guard let self = self else { return }
            
            switch index {
            case 1:
                slideUpViewController?.dismissWithAnimation({ [weak self] in
                    self?.didPressCreateButton()
                })
            case 2:
                slideUpViewController?.dismissWithAnimation({ [weak self] in
                    self?.didPressSendEstimateButton()
                })
            case 3:
                slideUpViewController?.dismissWithAnimation({ [weak self] in
                    self?.addScheduleServicePressed()
                })
            case 4:
                slideUpViewController?.dismissWithAnimation({ [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                })
            default: break
            }
        }).padding(10)))
        
        slideUpViewController = SlideUpViewController.instantiate(with: vc, size: CGSize(width: 0, height: 420))
        
        self.present(slideUpViewController!, animated: false, completion: nil)
    }
}
