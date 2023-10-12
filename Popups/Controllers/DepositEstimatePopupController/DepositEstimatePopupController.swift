//
//  DepositEstimatePopupController.swift
//  Motorvate
//
//  Created by Nikita Benin on 10.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import SafariServices
import UIKit

protocol DepositEstimatePopupControllerDelegate: AnyObject {
    func handleEditDetails(serviceType: ServiceType, type: DepositEstimateType, fee: DepositFeeType)
    func sendLink(serviceType: ServiceType, type: DepositEstimateType, fee: DepositFeeType)
}

class DepositEstimatePopupController: PopupController {

    // MARK: - UI Elements
    private let depositEstimatePopupView = DepositEstimatePopupView()
    
    // MARK: - Variables
    private let viewModel: DepositEstimatePopupViewModel
    private weak var delegate: DepositEstimatePopupControllerDelegate?
    
    // MARK: - Lifecycle
    init(
        viewModel: DepositEstimatePopupViewModel,
        delegate: DepositEstimatePopupControllerDelegate? = nil,
        needAnimateAppear: Bool = true
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        depositEstimatePopupView.setView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil, needAnimateAppear: needAnimateAppear)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
        depositEstimatePopupView.handleDepositSizeChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needAnimateAppear {
            depositEstimatePopupView.transform = CGAffineTransform(translationX: 0, y: 500)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needAnimateAppear {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.depositEstimatePopupView.transform = CGAffineTransform(translationX: 0, y: 0)
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func handleSendEstimationLink() {
        animateDisappear { [weak self] _ in
            self?.dismiss(animated: false, completion: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.sendLink(
                    serviceType: strongSelf.viewModel.serviceType,
                    type: strongSelf.viewModel.depositEstimateType,
                    fee: strongSelf.viewModel.depositFeeType
                )
            })
        }
    }
    
    private func showPreview(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        present(SFSafariViewController(url: url), animated: true)
    }
        
    // MARK: - UI Setup
    private func setView() {
        depositEstimatePopupView.handleEditDetails = { [weak self] in
            guard self?.viewModel.isEditingEnabled ?? true else {
                self?.present(PaymentConfirmationPopupController(), animated: false)
                return
            }
            self?.animateDisappear { [weak self] _ in
                self?.dismiss(animated: false, completion: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.handleEditDetails(
                        serviceType: strongSelf.viewModel.serviceType,
                        type: strongSelf.viewModel.depositEstimateType,
                        fee: strongSelf.viewModel.depositFeeType
                    )
                })
            }
        }
        depositEstimatePopupView.handleGetPreviewLink = { [weak self] in
            guard let strongSelf = self else { return }
            guard !strongSelf.viewModel.serviceDetails.isEmpty else {
                self?.presentAlert(title: nil, message: "Add items to the work or service order first")
                return
            }
            
            strongSelf.depositEstimatePopupView.isLoadingPreview(true)
            strongSelf.viewModel.handleGetPreviewLink { [weak self] result in
                self?.depositEstimatePopupView.isLoadingPreview(false)
                switch result {
                case .success(let url):
                    self?.showPreview(urlString: url)
                case .failure(let error):
                    self?.presentAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
        depositEstimatePopupView.handleSendEstimationLink = { [weak self] in
            guard self?.viewModel.isEditingEnabled ?? true else {
                self?.present(PaymentConfirmationPopupController(), animated: false)
                return
            }
            self?.handleSendEstimationLink()
        }
        view.addSubview(depositEstimatePopupView)
    }
    
    private func setupConstraints() {
        depositEstimatePopupView.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Appearance animation
    override func animateDisappear(completion: ((Bool) -> Void)?) {
        super.animateDisappear(completion: completion)
        depositEstimatePopupView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.depositEstimatePopupView.transform = CGAffineTransform(translationX: 0, y: 500)
            self.view.layoutIfNeeded()
        })
    }
}
