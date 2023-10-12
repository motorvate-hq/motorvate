//
//  JobsViewController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-25.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class JobsViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<SectionJobData, Job>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionJobData, Job>

    private var _shopExist: Bool {
        UserSession.shared.shopID != nil
    }

    lazy var dataSource = makeDatasource()

    lazy var filterView: FilterView = {
        let filter = FilterView(titles: ["All", "In Queue", "In Progress"])
        filter.delegate = self
        return filter
    }()

    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.register(JobCell.self)
        collectionView.register(JobFooterReusableView.self, supplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()

    lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate var animatingDifference: Bool = false

    let viewModel: JobsViewModel
    weak var coordinatorDelegate: JobsCoordinatorDelegate?

    init(viewModel: JobsViewModel, delegate: JobsCoordinatorDelegate?) {
        self.viewModel = viewModel
        self.coordinatorDelegate = delegate
        super.init(nibName: nil, bundle: nil)

        addNotificationObserver()
        addListener()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
        setUpBackButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = UserSession.shared.shopName
        tabBarItem.title = "Jobs"

        configureCollectionView()
        fetchAllJobs()

        presentWalkthroughFlowIfNecessary()
    }

    @objc func onSettingsPressed() {
        coordinatorDelegate?.showSettings()
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: view.frame.width - 16, height: JobCell.cellHeight)
            layout.minimumInteritemSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }

        setConstraints()
    }

    func setNavigationBarItem() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.backgroundColor = .systemBackground
        navigationBar?.isTranslucent = false
        navigationBar?.tintColor = UIColor(named: "componentText")
        
        let settingButtonItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "icon_settings"), style: .plain, target: self, action: #selector(onSettingsPressed))
        navigationItem.leftBarButtonItem = settingButtonItem
        
        let notificationsButtonItem = BadgedButtonItem(with: R.image.notification())
        notificationsButtonItem.addTarget(self, action: #selector(onNotificationsPressed), event: .touchUpInside)
        notificationsButtonItem.setBadge(with: UserSettings().notificationsCenterCounter)
        
        navigationItem.rightBarButtonItem = notificationsButtonItem
    }
    
    @objc private func onNotificationsPressed() {
        handleShowNotificationCenter(showTransactions: false)
    }
    
    func handleShowNotificationCenter(showTransactions: Bool) {
        let notificationCenterController = NotificationCenterController()
        notificationCenterController.disappearHandler = { [weak self] in self?.setNavigationBarItem() }
        if showTransactions {
            notificationCenterController.handleViewTransactions()
        }
        present(notificationCenterController, animated: false)
    }

    @objc private func fetchAllJobs() {
        viewModel.fetchAllJobs()
    }

    private func addListener() {
        viewModel.reloadAction = { [weak self] in
            self?.setAsLoading(false)
            self?.applySnapshot()
        }
    }

    private func setUpBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    private func setConstraints() {
        view.addSubview(headerView)
        view.addSubview(filterView)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 92),

            filterView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            filterView.heightAnchor.constraint(equalToConstant: 60),

            collectionView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)])
    }

    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAllJobs), name: .JobsViewControllerFetchAllJobs, object: nil)
    }
    
    private func presentDetails(of job: Job) {
        let jobDetailsViewController = ServiceDetailsViewController(
            viewModel:
                JobDetailsViewModel(
                    job: job,
                    depositFeeType: .exclude
                ), excludingDeposit: false
        )
        navigationController?.pushViewController(jobDetailsViewController, animated: true)        
    }

    private func presentWalkthroughFlowIfNecessary() {
        let settings = UserSettings()
        guard !settings.hasSeenEstimateWalkthroughFlow else { return }
        settings.hasSeenEstimateWalkthroughFlow = true

        UIView.animate(withDuration: 3.0) {
            self.showEstimatePopup()
        }
    }
}

extension JobsViewController {
    func applySnapshot() {
        var snapshot = Snapshot()
        let sectionData = viewModel.section
        snapshot.appendSections(sectionData)
        sectionData.forEach { section in
            snapshot.appendItems(section.jobs, toSection: section)
        }

        updateEmptyStateShowing(for: sectionData)
        dataSource.apply(snapshot, animatingDifferences: animatingDifference)
    }

    private func makeDatasource() -> DataSource {
        let datasource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, job) -> UICollectionViewCell? in
            let cell: JobCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(for: job)
            return cell
        })
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionFooter:
                let header: JobFooterReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, indexPath: indexPath)
                return header
            default: break
            }
            return UICollectionReusableView()
        }
        return datasource
    }
}

// MARK: - HeaderViewDelegate
extension JobsViewController: HeaderViewDelegate {
    func headerView(didSelect section: HeaderView.Section) {
        switch section {
        case .newInquiry:
            coordinatorDelegate?.showInquiryView()
        case .newDropOff:
            showNewDropOffView()
        case .startOnboard:
            let requestMeta = JobRequestMeta()
            coordinatorDelegate?.showOnBoardingWith(params: requestMeta, shouldPush: false, shouldShowCustomerInquiryView: true, presenter: nil)
        }
    }

    private func showNewDropOffView() {
        let jobsViewModel = JobsViewModel(JobService(), InquiryService())
        coordinatorDelegate?.showNewDropoffView(jobsViewModel, shouldPush: false)
    }
}

extension JobsViewController: JobCellDelegate {
    func jobCell(_ jobCell: JobCell, didSelectButton type: JobCellButtonType, job: Job?) {
        switch type {
        case .message:
            guard let customerID = job?.customerID, let jobId = job?.jobID else { return }
            presentMessageViewController(customerID, jobId: jobId, sendInvoice: false)
        case .status:
            let indexPath = collectionView.indexPath(for: jobCell)
            presentActionController(at: indexPath, job: job)
        }
    }
    
    func presentMessageViewController(_ customerID: String, jobId: String, sendInvoice: Bool) {
        let chatViewModel = ChatViewModel(customerID: customerID, inquiryId: nil, jobId: jobId)
        let chatViewController = ChatViewController(viewModel: chatViewModel)
        chatViewController.shouldSendInvoice = sendInvoice
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension JobsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.isLast(section: section) {
            return .zero
        }
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let job = viewModel.item(at: indexPath)
        presentDetails(of: job)
    }
}

// MARK: FilterViewDelegate
extension JobsViewController: FilterViewDelegate {
    func filterView(didSelect status: Job.Status) {
        filterView.selectStatus(status)
        animatingDifference = status != .none
        viewModel.filter(for: status)
        collectionView.scrollToTop()
    }
}

extension JobsViewController {
    func updateEmptyStateShowing(for section: [SectionJobData]) {
        if section.isEmpty {
            showEmptyState()
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    private func showEmptyState() {
        collectionView.backgroundView = EmptyDataPlaceholderView(type: .noJobsView, action: { [weak self] action in
            switch action {
            case .sendServiceForm: self?.headerView(didSelect: .newInquiry)
            case .newService: self?.headerView(didSelect: .newDropOff)
            case .onboard: self?.headerView(didSelect: .startOnboard)
            case .tutorial:
                AnalyticsManager.logEvent(.watchOnboardTutorial)
                UserSettings().hasSeenHowOnboardVideo = true
                self?.present(VideoController(videoType: .vehilceOnboardingTutorial), animated: true)
            }
        })
    }
}

extension JobsViewController {
    func showEstimatePopup() {
        let estimatePopupController = EstimatePopupController()
        estimatePopupController.learnMoreHandler = startEstimateWalkthrough
        present(estimatePopupController, animated: false, completion: nil)
    }
    
    func startEstimateWalkthrough() {
        let walkthroughViewController = EstimateWalkthroughController()
        present(walkthroughViewController, animated: false, completion: nil)
    }
}

// extension JobsViewController: WalkthroughControllerDelegate {
//    func startWalkthrough() {
//        let walkthroughViewController = WalkthroughController()
//        walkthroughViewController.modalPresentationStyle = .overFullScreen
//        present(walkthroughViewController, animated: false, completion: nil)
//    }
//
//    func popToRootViewController() {
//        navigationController?.popToRootViewController(animated: true)
//    }
//
//    func popViewController() {
//        navigationController?.popViewController(animated: true)
//    }
//
//    func showMessages() {
//        let chatViewModel = ChatViewModel(isWalkthrough: true)
//        let chatViewController = ChatViewController(viewModel: chatViewModel)
//        navigationController?.pushViewController(chatViewController, animated: true)
//    }
//
//    func showWalkthroughJobDetails(job: Job) {
//        presentDetails(of: job)
//    }
//
//    func showWalkthroughAddJobDetials() {
//        let addEditServiceController = AddEditServiceController(jobDetail: nil)
//        navigationController?.pushViewController(addEditServiceController, animated: true)
//    }
//
//    func showConnectBank() {
//        if presentedViewController == nil {
//            let connectBankPopupController = ConnectBankPopupController()
//            connectBankPopupController.delegate = self
//            present(connectBankPopupController, animated: false, completion: nil)
//        }
//    }
// }

extension JobsViewController: ConnectBankPopupDelegate {
    func showSafariController(url: URL) {
        let vc = WebController(url: url)
        if presentedViewController != nil {
            presentedViewController?.dismiss(animated: false, completion: { [weak self] in
                self?.present(vc, animated: true)
            })
        } else {
            present(vc, animated: true)
        }
    }
}
