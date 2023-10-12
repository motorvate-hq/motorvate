//
//  ScheduledServiceCoordinator.swift
//  Motorvate
//
//  Created by Motorvate on 6.3.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import UIKit

class ScheduledServiceCoordinator: Coordinator {
    fileprivate let presenter: UINavigationController

    var controller: UIViewController {
        return presenter
    }

    init(presenter: UINavigationController = UINavigationController()) {
        self.presenter = presenter
        
        self.refresh()
    }

    func start() {}
    
    func refresh() {
        self.presentPaywall()
        
        // check if the user is entitled from the purchase SDK
        Task {
            let isEntitled = await PurchaseKit.isEntitled(to: .base)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard isEntitled else {
                    // present the paywall
                    self.presentPaywall()
                    return
                }

                self.showScheduleDropOffView(canShowPaywallConfirmationView: false)
            }
        }
    }
    
    func showScheduleDropOffView(canShowPaywallConfirmationView: Bool) {
        let scheduleDropOffViewController = ScheduleDropOffView(canShowPaywallConfirmationView: canShowPaywallConfirmationView, onLoadCallback: { vc in
            vc?.navigationItem.setHidesBackButton(true, animated: false)
            vc?.navigationItem.title = "Scheduled Service"
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            vc?.navigationItem.backBarButtonItem = backItem
        }).embeddedInHostingController()
        
        scheduleDropOffViewController.title = "Scheduled Service"
        scheduleDropOffViewController.tabBarItem = UITabBarItem(title: "Scheduled", image: R.image.upcoming(), tag: 1)
        scheduleDropOffViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        presenter.viewControllers = [scheduleDropOffViewController]
    }
    
    func presentPaywall() {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.delegate = self
        subscriptionViewController.tabBarItem = UITabBarItem(title: "Scheduled", image: R.image.upcoming(), tag: 1)
        subscriptionViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        presenter.viewControllers = [subscriptionViewController]
    }
}

extension ScheduledServiceCoordinator: SubscriptionViewControllerDelegate {
    func didCompletePurchase() {
        self.showScheduleDropOffView(canShowPaywallConfirmationView: true)
    }
}
