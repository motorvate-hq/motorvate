//
//  MainTabBarController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-24.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private var _jobsCoordinator: JobsCoordinator?
    private var _scheduledServiceCoordinator: ScheduledServiceCoordinator?
    private var _customerCoordinator: CustomersCoordinator?
    private var _communicationCoordinator: CommunicationCoordinator?

    static var selectedTabIndex = Box<Int>(0)
    private var indicatorView: UIView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationRepository.shared.requestAuthorization()
        
        _scheduledServiceCoordinator?.refresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let jobsCoordinator = JobsCoordinator(presenter: BaseNavigationController())
        _jobsCoordinator = jobsCoordinator

        let scheduledServiceCoordinator = ScheduledServiceCoordinator(presenter: BaseNavigationController())
        _scheduledServiceCoordinator = scheduledServiceCoordinator

        let communicationCoordinator = CommunicationCoordinator(presenter: BaseNavigationController())
        _communicationCoordinator = communicationCoordinator
        
        let customerCoordinator = CustomersCoordinator(presenter: BaseNavigationController())
        _customerCoordinator = customerCoordinator

        viewControllers = [jobsCoordinator.controller, scheduledServiceCoordinator.controller, communicationCoordinator.controller, customerCoordinator.controller]

        MainTabBarController.selectedTabIndex.bind { [weak self] (index) in
            guard let strongSelf = self else { return }
            if strongSelf.selectedIndex != index {
                strongSelf.selectedIndex = index
                strongSelf.moveIndicator(to: index)
                
                if index == 1 {
                    UIApplication.shared.applicationIconBadgeNumber = UserSettings().totalNotificationsCounter
                    strongSelf.showInquiryFormsPopupIfNeeded()
                }
                
                strongSelf.hideNotificationsCounter(index: index)
            }
        }

        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
        tabBar.isTranslucent = false
        setupSelectionIndicatorView()
        
        addNotificationObserver()
        showNotificationCounter()
    }

    // MARK: - UI
    
    private func setupSelectionIndicatorView() {
        guard let firstView = tabBar.subviews.first else {
            return
        }

        guard let items = tabBar.items else {
            return
        }

        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 12)

        let numberOfItems = CGFloat(items.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)

        indicatorView = createSelectionIndicator()
        indicatorView.center.x = 0 + tabBarItemSize.width / 2
        indicatorView.center.y = 0 + tabBarItemSize.height / 2
        tabBar.insertSubview(indicatorView, belowSubview: firstView)
    }

    private func createSelectionIndicator(color: UIColor = .white, size: CGSize = CGSize(width: 37, height: 37)) -> UIView {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.height, height: size.height)
        let view = UIView(frame: rect)
        view.backgroundColor = color
        view.layer.cornerRadius = rect.height / 2
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(white: 0.75, alpha: 1.0).cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .init(width: 2, height: 2)
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }

    // MARK: - Operations
    private func moveIndicator(to index: Int) {
        guard let items = tabBar.items else {
            return
        }

        let itemSize = (tabBar.frame.width / CGFloat(items.count))
        let indicatorXValue = (itemSize * CGFloat(index + 1)) - (itemSize / 2)

        indicatorView.center.x = indicatorXValue
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showInqueueJobsOnScreen), name: .showInqueueJobsOnScreen, object: nil)
        NotificationRepository.shared.addListener(self)
    }
    
    @objc private func showInqueueJobsOnScreen() {
        MainTabBarController.selectedTabIndex.value = 0
        if let navigationController = viewControllers?.first as? UINavigationController,
           let jobsViewController = navigationController.viewControllers.first as? JobsViewController {
            jobsViewController.filterView(didSelect: .inqueue)
        }
    }
    
    func showInquiryScreen() {
        popToMainTabBar()
        MainTabBarController.selectedTabIndex.value = 1
    }
    
    private func showMessagesScreen() {
        popToMainTabBar()
        MainTabBarController.selectedTabIndex.value = 2
    }
    
    func showNewInquiry() {
        if let navigationController = viewControllers?.first as? UINavigationController,
           let jobsViewController = navigationController.viewControllers.first as? JobsViewController {
            jobsViewController.coordinatorDelegate?.showInquiryView()
        }
    }
    
    private func popToMainTabBar() {
        presentedViewController?.dismiss(animated: false)
        guard let viewController = viewControllers?[selectedIndex],
              let currentNavigationViewController = viewController as? UINavigationController
                    else { return }
        currentNavigationViewController.popToRootViewController(animated: false)
    }
      
    private func showInquiryFormsPopupIfNeeded() {
        if !UserSettings().didShowInquiryFormsPopup && presentedViewController == nil {
            present(InquiryFormsPopupController(), animated: false, completion: nil)
        }
    }
    
    private func showPaymentTransactions() {
        popToMainTabBar()
        if let navigationController = viewControllers?.first as? UINavigationController,
           let jobsViewController = navigationController.viewControllers.first as? JobsViewController {
            jobsViewController.handleShowNotificationCenter(showTransactions: true)
        }
    }
    
    private func showPaymentConfirmationPopup() {
        if presentedViewController == nil {
            present(PaymentConfirmationPopupController(), animated: false)
        }
    }
    
    private func updateNotificationCenterCounter() {
        if let navigationController = viewControllers?.first as? UINavigationController,
           let jobsViewController = navigationController.viewControllers.first as? JobsViewController {
            jobsViewController.setNavigationBarItem()
        }
    }
    
    private func showNotificationCounter() {
        if let items = tabBar.items, items.count > 1, UserSettings().inquiriesNotificationsCounter != 0 {
            items[1].badgeValue = "\(UserSettings().inquiriesNotificationsCounter)"
        }
        if let items = tabBar.items, items.count > 2, UserSettings().messagesNotificationsCounter != 0 {
            items[2].badgeValue = "\(UserSettings().messagesNotificationsCounter)"
        }
    }
    
    private func hideNotificationsCounter(index: Int) {
        switch index {
        case 1:
            UserSettings().inquiriesNotificationsCounter = 0
            if let items = tabBar.items, items.count > 1 {
                items[1].badgeValue = nil
            }
        case 2:
            UserSettings().messagesNotificationsCounter = 0
            if let items = tabBar.items, items.count > 2 {
                items[2].badgeValue = nil
            }
        default: break
        }
    }
}

// MARK: NotificationRepositoryListener
extension MainTabBarController: NotificationRepositoryListener {    
    func receivedNotification(type: APNsNotificationType) {
        switch type {
        case .newMessage, .newDepositEstimateConfirm:
            UserSettings().messagesNotificationsCounter += 1
            if let items = tabBar.items, items.count > 2 {
                items[2].badgeValue = "\(UserSettings().messagesNotificationsCounter)"
            }
        case .newInquiry:
            UserSettings().inquiriesNotificationsCounter += 1
            if let items = tabBar.items, items.count > 1 {
                items[1].badgeValue = "\(UserSettings().inquiriesNotificationsCounter)"
            }
        case .depositPaid:
            UserSettings().depositPaidNotificationsCounter += 1
            updateNotificationCenterCounter()
            showPaymentConfirmationPopup()
        }
        UIApplication.shared.applicationIconBadgeNumber = UserSettings().totalNotificationsCounter
    }
    
    func receivedNotificationInteraction(type: APNsNotificationType) {
        switch type {
        case .newMessage, .newDepositEstimateConfirm:
            showMessagesScreen()
        case .newInquiry:
            showInquiryScreen()
        case .depositPaid:
            showPaymentTransactions()
        }
    }
}

// MARK: - UITabBar
extension MainTabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        MainTabBarController.selectedTabIndex.value = item.tag
    }
}

extension Notification.Name {
    static let showInqueueJobsOnScreen = Notification.Name("showInqueueJobsOnScreen")
}
