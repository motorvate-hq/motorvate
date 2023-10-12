//
//  ServiceDetailsViewController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-12-01.
//  Copyright © 2019 motorvate. All rights reserved.
//

import SafariServices
import UIKit

private struct Constants {
    static let addServiceButtonSize = CGSize(width: 110, height: 45)
}

final class ServiceDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let stackScrollView: StackScrollView = {
        let stackScrollView = StackScrollView(contentEdgeInsets: .init(top: 16, left: 16, bottom: 120, right: 16))
        stackScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackScrollView.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        return stackScrollView
    }()
    private let addServiceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Service", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 15)
        button.layer.addShadow(
            backgroundColor: UIColor(red: 1, green: 0.682, blue: 0.075, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 5,
            shadowRadius: 10,
            shadowOffset: CGSize(width: 0, height: 4)
        )
        return button
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(ServiceCell.self)
        tableView.separatorInset = .zero
        return tableView
    }()
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 7
        return stackView
    }()
    private let feePriceView = DepositEstimatePriceView(title: "Service fee:", subtitle: "")
    private let estimatePriceView = DepositEstimatePriceView(title: "Estimate:", subtitle: "You will recieve")
    private let customerPriceView = DepositEstimatePriceView(title: "Ask for:", subtitle: "Customer will recieve")
    private let serviceDetailsPaymentsView = ServiceDetailsPaymentsView()
    
    // MARK: - Variables
    private var viewModel: DetailsViewModel
    
    var excludingDeposit: Bool
    
    // MARK: - Init
    init(viewModel: DetailsViewModel, excludingDeposit: Bool) {
        self.viewModel = viewModel
        self.excludingDeposit = excludingDeposit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title

        bind()
        setUI()
    }
    
    func bind() {
        viewModel.isLoading.bind { [weak self] isLoading in
            self?.setAsLoading(isLoading)
        }
    }
    
    private func showPreview(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        present(SFSafariViewController(url: url), animated: true)
    }
    
    // MARK: - UI
    private func setUI() {
        let contactInformation = CustomerJobDetailsModuleView(
            details: [
                .title("Contact Information"),
                .divider(height: 1),
                .subtitle(viewModel.customerFullNameText),
                .subtitle(viewModel.phoneNumberText.setFormat(with: "+X XXX XXX XXXX")),
                .subtitle(viewModel.emailText)
            ]
        )
        
        let jobServiceInformation = CustomerJobDetailsModuleView(
            details: [
                .title("Job Information"),
                .divider(height: 1),
                .subtitleWithText(
                    subtitle: viewModel.vehicleInfoText,
                    text: viewModel.noteText
                ),
                .divider(height: 18),
                .subtitleWithText(
                    subtitle: "Service Information",
                    text: ""
                ),
                .custom(view: tableView),
                .custom(view: vStackView),
                .subtitleWithText(subtitle: "", text: viewModel.descriptionText)
            ]
        )
        
        vStackView.addArrangedSubview(feePriceView)
        vStackView.addArrangedSubview(estimatePriceView)
        vStackView.addArrangedSubview(customerPriceView)
        
        feePriceView.isHidden = excludingDeposit
        customerPriceView.isHidden = excludingDeposit
        
        view.addSubview(stackScrollView)
        stackScrollView.fillSuperView()
        stackScrollView.insertView(contactInformation)
        stackScrollView.insertView(jobServiceInformation)
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(ServiceCell.height * CGFloat(viewModel.serviceDetails.count))
        }
        updatePrices()
        setEditButton()
        setPaymentDetailsSection()
    }
    
    private func setEditButton() {
        if viewModel.shouldShowEditButton {
            addServiceButton.addTarget(self, action: #selector(handleAddService), for: .touchUpInside)
            view.addSubview(addServiceButton)
            addServiceButton.snp.makeConstraints { (make) -> Void in
                make.bottom.equalTo(view.safeArea.bottom).inset(30)
                make.right.equalToSuperview().inset(13)
                make.size.equalTo(Constants.addServiceButtonSize)
            }
        }
    }
    
    private func setPaymentDetailsSection() {
        if let inquiryPaidDetail = viewModel.inquiryPaidDetail {
            addServiceButton.isHidden = true
            stackScrollView.contentEdgeInsets.bottom = 16
            
            serviceDetailsPaymentsView.setView(inquiryPaidDetail: inquiryPaidDetail)
            serviceDetailsPaymentsView.handleGetPreviewLink = { [weak self] in
                self?.previewLinkHandler()
            }
            stackScrollView.insertView(serviceDetailsPaymentsView)
        }
    }
    
    private func previewLinkHandler() {
        setAsLoading(true)
        viewModel.handleGetPreviewLink(completion: { [weak self] result in
            self?.setAsLoading(false)
            switch result {
            case .success(let urlString):
                self?.showPreview(urlString: urlString)
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    private func updateTableData(serviceDetails: [ServiceDetail]) {
        viewModel.serviceDetails = serviceDetails
        updatePrices()
        tableView.reloadData()
        updateTableViewHeight()
    }
    
    private func updatePrices() {
        estimatePriceView.value = String(format: "$%.2f", viewModel.estimatePrice)
        customerPriceView.value = String(format: "$%.2f", viewModel.customerPrice)
        feePriceView.value = String(format: "$%.2f", viewModel.feePrice)
    }
    
    private func updateTableViewHeight() {
        tableView.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(ServiceCell.height * CGFloat(viewModel.serviceDetails.count))
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc private func handleAddService() {
        showAddEditService()
    }
    
    private func showAddEditService(indexPath: IndexPath? = nil) {
        var jobDetail: ServiceDetail?
        if let index = indexPath?.row {
            jobDetail = viewModel.serviceDetails[index]
        }
        
        let addEditServiceController = AddEditServiceController(jobDetail: jobDetail)
        addEditServiceController.delegate = self
        navigationController?.pushViewController(addEditServiceController, animated: true)
    }
    
    private func handleDeleteService(indexPath: IndexPath) {
        viewModel.deleteService(item: viewModel.serviceDetails[indexPath.row]) { [weak self] result in
            switch result {
            case .success(let serviceDetails):
                self?.updateTableData(serviceDetails: serviceDetails)
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ServiceDetailsViewController: UITableViewDelegate { }

// MARK: - UITableViewDataSource
extension ServiceDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.serviceDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ServiceCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setCell(
            item: viewModel.serviceDetails[indexPath.row],
            deleteActionHandler: { [weak self] in
                self?.handleDeleteService(indexPath: indexPath)
            },
            editActionHandler: { [weak self] in
                self?.showAddEditService(indexPath: indexPath)
            }
        )
        return cell
    }
}

// MARK: - AddEditServiceDelegate
extension ServiceDetailsViewController: AddEditServiceDelegate {
    func didAddUpdateService(jobDetail: ServiceDetail, isUpdate: Bool) {
        viewModel.addUpdateService(item: jobDetail) { [weak self] result in
            switch result {
            case .success(let serviceDetails):
                AnalyticsManager.logEvent(isUpdate ? .jobServiceChanged(price: jobDetail.price) : .jobServiceAdded(price: jobDetail.price))
                self?.updateTableData(serviceDetails: serviceDetails)
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
