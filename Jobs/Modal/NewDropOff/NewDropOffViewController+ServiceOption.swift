//
//  NewDropOffViewController+ServiceOption.swift
//  Motorvate
//
//  Created by Emmanuel on 2/1/23.
//  Copyright © 2023 motorvate. All rights reserved.
//

import UIKit
import SwiftUI

extension NewDropOffViewController {
    func addScheduleServicePressed() {
        guard validateInputFields() else { return }

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

                self.showScheduleDropOffView(false)
            }
        }
    }

    private func presentPaywall() {
        let subscriptionViewController = SubscriptionViewController()
        subscriptionViewController.delegate = self
        let navController = UINavigationController(rootViewController: subscriptionViewController)
        navController.modalPresentationStyle = .currentContext
        navigationController?.present(navController, animated: true)
    }

    func showScheduleDropOffView(_ showPaywallConfirmationView: Bool) {
        let vc = ScheduleDropOffView(canShowPaywallConfirmationView: showPaywallConfirmationView, onLoadCallback: { vc in
            vc?.navigationItem.setHidesBackButton(true, animated: false)
            vc?.navigationItem.title = "Scheduled Service"
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            vc?.navigationItem.backBarButtonItem = backItem
        }).embeddedInHostingController()
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen

        if self.presentingViewController != nil {
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.didPressCloseButton))
        }

        self.present(nc, animated: true)
    }
}

// MARK: - SubscriptionViewControllerDelegate
extension NewDropOffViewController: SubscriptionViewControllerDelegate {
    func didCompletePurchase() {
        showScheduleDropOffView(true)
    }
}
