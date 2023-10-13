//
//  MotorvateTests.swift
//  MotorvateTests
//
//  Created by Nikita Benin on 29.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

@testable import Motorvate
import XCTest

class MotorvateTests: XCTestCase {
    
    func test_InquiryViewController_UI() {
        let vc = InquiryViewController(viewModel: JobsViewModel(JobService(), InquiryService()))
        verifyViewController(vc)
    }
    
    func test_ConnectBankPopupController_UI() {
        let vc = ConnectBankPopupController(needAnimateAppear: false)
        verifyViewController(vc)
    }
    
    func test_EstimatePopupController_UI() {
        let vc = EstimatePopupController(needAnimateAppear: false)
        verifyViewController(vc)
    }
    
    func test_DepositEstimatePopupController_UI() {
        let viewModel = DepositEstimatePopupViewModel(serviceDetails: [
            ServiceDetail(id: nil, description: "Irdium Silver", price: 1700),
            ServiceDetail(id: nil, description: "Car wash", price: 100)
        ])
        let vc = DepositEstimatePopupController(viewModel: viewModel, needAnimateAppear: false)
        verifyViewController(vc)
    }
    
    func test_CompleteJobPopupController_UI() {
        let vc = CompleteJobPopupController(handleSendInvoice: {}, handleComplete: {}, needAnimateAppear: false)
        verifyViewController(vc)
    }
    
    func test_ErrorPopupController_UI() {
        let vc = ErrorPopupController(title: nil, message: nil, handler: nil, needAnimateAppear: false)
        verifyViewController(vc)
    }
    
    func test_NewDropOffViewController_UI() {
        let viewModel = JobsViewModel(JobService(), InquiryService())
        let vc = NewDropOffViewController(viewModel)
        let navigationController = UINavigationController(rootViewController: vc)
        #warning("FIXME: Update UI here. Right now UI requires a delay to full draw.")
        verifyViewController(navigationController, wait: 5)
    }
    
    func test_SettingsViewController_UI() {
        let viewModel = SettingsViewModel(AccountService())
        let vc = SettingsViewController(viewModel)
        let navigationController = UINavigationController(rootViewController: vc)
        verifyViewController(navigationController)
    }
    
    func test_buttonDefaultState() {
        let button = PopupActionButton(style: .blue)
        button.frame = .init(x: 0, y: 0, width: 128, height: 48)
        button.setTitle("Login", for: .normal)
        verifyView(view: button, state: "Default")
    }
    
    func test_buttonLoadingState() {
        let button = PopupActionButton(style: .blue)
        button.frame = .init(x: 0, y: 0, width: 128, height: 48)
        button.setTitle("Login", for: .normal)
        button.setAsLoading(true)
        verifyView(view: button, state: "Loading")
    }
}
