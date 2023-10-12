//
//  UpcomingViewController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-25.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

private enum Constants {
    static let backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
    static let cellHeight: CGFloat = 100.0
    static let deleteIcon = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 20)).image { _ in
        R.image.serviceDelete()?
            .withTintColor(.darkGray)
            .draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
    }
}

final class InquiryListViewController: UIViewController {

    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = Constants.backgroundColor
        tableView.register(UpcomingCell.self)
        tableView.register(DateSectionHeaderFooterView.self)
        tableView.contentInset.top = 15
        tableView.sectionHeaderHeight = 26
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let refreshControl = UIRefreshControl()

    // MARK: - Variables
    fileprivate let viewModel: InquiryListViewModel
    private typealias Snapshot = NSDiffableDataSourceSnapshot<InquiryListSectionItem, Inquiry>
    private typealias DataSource = InquiryListDataSource
    private lazy var dataSource = makeDatasource()
    weak var coordinator: InquiryListCoordinatorDelegate?
    private var isRefreshing: Bool = false

    // MARK: - Lifecycle
    init(viewModel: InquiryListViewModel = InquiryListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func refreshData() {
        isRefreshing = true
        fetchInquiries()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchInquiries()
        addNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpBackButton()
        
        self.navigationItem.title = "Inquiries"
    }
    
    private func setUpBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - NSDiffableDataSourceSnapshot & UITableViewDiffableDataSource
extension InquiryListViewController {
    private func makeDatasource() -> DataSource {
        let datasource = DataSource(tableView: tableView) { [weak self] (tableView, indexPath, _) -> UITableViewCell? in
            guard let strongSelf = self else { return nil }
            let cell: UpcomingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = strongSelf
            cell.configure(with: strongSelf.viewModel, indexPath: indexPath)
            return cell
        }
        return datasource
    }

    private func applySnapshot(data: [InquiryListSectionItem], animatingDifferences: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections(data)
        data.forEach { section in
            snapshot.appendItems(section.inquiriesList, toSection: section)
        }
        
        updateEmptyStateShowing()
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - Helpers
private extension InquiryListViewController {
    @objc func fetchInquiries() {
        guard let shopID = UserSession.shared.shopID else { return }
        isRefreshing ? nil : setAsLoading(true)
        viewModel.getAllInquiriesForShop(with: shopID ) { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.isRefreshing ? nil : strongSelf.setAsLoading(false)
            strongSelf.isRefreshing = false
            strongSelf.applySnapshot(data: data)
        }
    }

    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refetchInquiries), name: .RefetchInquiries, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didCloseInquiry), name: .InquiryClosedSuccessfully, object: nil)
        
        NotificationRepository.shared.addListener(self)
    }

    @objc func refetchInquiries() {
        fetchInquiries()
    }

    @objc func didCloseInquiry(notification: Notification) {
        if notification.userInfo?[OnboardViewModel.inquiryIdentifierKey] as? String != nil {
            fetchInquiries()
        }
    }
}

extension InquiryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
            if let data = self?.viewModel.handleDeleteItem(at: indexPath, completion: { response, tempData  in
                if !response {
                    self?.applySnapshot(data: tempData, animatingDifferences: true)
                    self?.presentAlert(message: "Unable to delete inquiry.")
                }
            }) {
                self?.applySnapshot(data: data, animatingDifferences: true)
            }
            completion(true)
        }
        deleteAction.backgroundColor = .white
        deleteAction.image = Constants.deleteIcon
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: DateSectionHeaderFooterView = tableView.dequeueReusableHeaderFooterView()
        guard let headerViewModel = viewModel.headerViewModel(at: section) else { return nil }
        header.configure(headerViewModel)
        return header
    }
}

// MARK: - UpcomingCellDelegate
extension InquiryListViewController: UpcomingCellDelegate {
    func upcomingCell(_ cell: UpcomingCell, didTapButton type: UpcomingCellButtonType) {
        switch type {
        case .onboard(let inquiry):
            coordinator?.showOnboarding(with: inquiry)
        case .sendMessage(let customerId, let inquiryId):
            presentMessageViewController(customerId, inquiryId: inquiryId)
        }
    }
    
    private func presentMessageViewController(_ customerID: String, inquiryId: String) {
        let chatViewModel = ChatViewModel(customerID: customerID, inquiryId: inquiryId, jobId: nil)
        let chatViewController = ChatViewController(viewModel: chatViewModel)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}

// MARK: - EmptyDataViewProviding
extension InquiryListViewController {
    func updateEmptyStateShowing() {
        guard viewModel.isEmpty else {
            tableView.backgroundView = nil
            return
        }
        
        tableView.backgroundView =
            EmptyDataPlaceholderView(
                type: .noInquiriesView,
                action: { [weak self] action in
                    switch action {
                    case .sendServiceForm: (self?.tabBarController as? MainTabBarController)?.showNewInquiry()
                    case .tutorial:
                        AnalyticsManager.logEvent(.watchOnboardTutorial)
                        UserSettings().hasSeenHowOnboardVideo = true
                        self?.present(VideoController(videoType: .vehilceOnboardingTutorial), animated: true)
                    default: break
                    }
                }
            )
    }
}

// MARK: - NotificationRepositoryListener
extension InquiryListViewController: NotificationRepositoryListener {    
    func receivedNotification(type: APNsNotificationType) {
        switch type {
        case .newInquiry: fetchInquiries()
        default:
            break
        }
    }
    
    func receivedNotificationInteraction(type: APNsNotificationType) {
        switch type {
        case .newInquiry: fetchInquiries()
        default:
            break
        }
    }
}

extension Notification.Name {
    static let RefetchInquiries = Notification.Name("RefetchInquiries")
}
