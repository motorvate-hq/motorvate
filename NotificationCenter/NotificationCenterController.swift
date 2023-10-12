//
//  NotificationCenterController.swift
//  Motorvate
//
//  Created by Nikita Benin on 17.02.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

import SafariServices

class NotificationCenterController: PopupController {
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(NotificationCenterHeaderView.self)
        tableView.register(NotificationCenterActionCell.self)
        tableView.register(NotificationCenterFeatureCell.self)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        return tableView
    }()
    
    // MARK: - Variables
    private let viewModel = NotificationCenterVM()
    var disappearHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.applicationIconBadgeNumber = UserSettings().totalNotificationsCounter
        disappearHandler?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
    }
    
    func handleActionTap(model: NotificationCenterActionModel) {
        switch model {
        case .viewNumber:
            let inquiryFormsPopupController = InquiryFormsPopupController()
            inquiryFormsPopupController.disappearHandler = { [weak self] in self?.tableView.reloadData() }
            present(inquiryFormsPopupController, animated: false)
        case .viewTransactions:
            handleViewTransactions()
        case .automateInquiries:
            AnalyticsManager.logEvent(.watchInquiryTutorial)
            UserSettings().hasSeenAutomateInquiriesVideo = true
            present(VideoController(videoType: .automateInquiries), animated: true)
        case .seeHowOnboard:
            AnalyticsManager.logEvent(.watchOnboardTutorial)
            UserSettings().hasSeenHowOnboardVideo = true
            present(VideoController(videoType: .vehilceOnboardingTutorial), animated: true)
        case .connectbank:
            if let url = URL(string: "https://www.motorvate.io/home/motorvate-invoicing/") {
                UserSettings().hasSeenConnectBank = true
                present(SFSafariViewController(url: url), animated: true)
            }
        case .partnerAffirm:
            if let url = URL(string: "https://www.motorvate.io/home/motorvatefinancing/") {
                UserSettings().hasSeenPartnerAffirm = true
                present(SFSafariViewController(url: url), animated: true)
            }
        case .learnEstimates:
            startEstimateWalkthrough()
        case .contactSupport:
            if let url = URL(string: "https://wa.link/amd0wm") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func startEstimateWalkthrough() {
        UserSettings().hasSeenEstimateWalkthroughFlow = true
        let walkthroughViewController = EstimateWalkthroughController()
        present(walkthroughViewController, animated: false, completion: nil)
    }
    
    func handleViewTransactions() {
        guard let shopId = UserSession.shared.shopID else {
            presentAlert(title: "Error", message: "Invalid shop id")
            return
        }
                
        setAsLoading(true)
        let request = GetStripeAccountRequest(shopID: shopId)
        StripeService().getStripeLoginLink(request: request) { [weak self] result in
            self?.setAsLoading(false)
            switch result {
            case .success(let response):
                if let url = URL(string: response.url) {
                    UserSettings().depositPaidNotificationsCounter = 0
                    self?.present(SFSafariViewController(url: url), animated: true)
                }
            case .failure(let error):
                var errorMessage = error.localizedDescription
                if errorMessage == NetworkResponse.authenticationError.message {
                    errorMessage = "Please connect bank / card to view transactions."
                }
                self?.presentAlert(title: "Error", message: errorMessage)
            }
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateAndDismiss))
        tableView.addGestureRecognizer(tapRecognizer)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate
extension NotificationCenterController: UITableViewDelegate { }

// MARK: - UITableViewDataSource
extension NotificationCenterController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: NotificationCenterActionCell = tableView.dequeueReusableCell(for: indexPath)
            let model = viewModel.actionModels[indexPath.row]
            cell.setCell(
                model: model,
                notificationCounter: viewModel.notificationCounterForModel(model),
                tapHandler: { [weak self] in self?.handleActionTap(model: model) }
            )
            return cell
        } else {
            let cell: NotificationCenterFeatureCell = tableView.dequeueReusableCell(for: indexPath)
            let model = viewModel.featureNotifications[indexPath.row]
            cell.setCell(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: NotificationCenterHeaderView = tableView.dequeueReusableHeaderFooterView()
        headerView.setView(title: viewModel.titleForSection(section: section))
        return headerView
    }
}
