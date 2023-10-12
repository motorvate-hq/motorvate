//
//  InquiryListCoordinator.swift
//  Motorvate
//
//  Created by Emmanuel on 2/12/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

protocol InquiryListCoordinatorDelegate: AnyObject {
    func showOnboarding(with inquiry: Inquiry)
}

class InquiryListCoordinator: Coordinator {
    fileprivate let presenter: UINavigationController

    var controller: UIViewController {
        return presenter
    }

    init(presenter: UINavigationController = UINavigationController()) {
        self.presenter = presenter

        let inquiryListViewController = InquiryListViewController()
        inquiryListViewController.coordinator = self
        inquiryListViewController.title = "Inquiries"
        inquiryListViewController.tabBarItem = UITabBarItem(title: "Scheduled", image: R.image.upcoming(), tag: 1)
        inquiryListViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        presenter.viewControllers = [inquiryListViewController]
    }

    func start() {}
}

extension InquiryListCoordinator: InquiryListCoordinatorDelegate {
    func showOnboarding(with inquiry: Inquiry) {
        let service = JobService()
        let viewModel = OnboardViewModel(service, requestMeta: JobRequestMeta())
        viewModel.shouldShowCustomerInquiryView = false
        viewModel.setIquiryIdentifier(inquiry.id)
        viewModel.serviceDetail = inquiry.inquiryDetails
        let viewController = makeRootViewController(OnboardingViewController(viewModel))
        presenter.present(viewController, animated: true, completion: nil)
    }

    private func makeRootViewController(_ rootViewController: UIViewController) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.modalPresentationStyle = .fullScreen
        return navController
    }
}
