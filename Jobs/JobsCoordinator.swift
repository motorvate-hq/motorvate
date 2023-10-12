//
//  JobsCoordinator.swift
//  Motorvate
//
//  Created by Emmanuel on 2/12/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

protocol JobsCoordinatorDelegate: AnyObject {
    func showSettings()
    func showInquiryView()
    func showNewDropoffView(_ viewModel: JobsViewModel, shouldPush: Bool)
    func showOnBoardingWith(params: JobRequestMeta, shouldPush: Bool, shouldShowCustomerInquiryView: Bool, presenter: UIViewController?)
    
    var mainTabBar: MainTabBarController? { get }
}

class JobsCoordinator: NSObject, Coordinator {
    private var childCoordinators = [Coordinator]()
    private let presenter: UINavigationController
    private var modalPresenter: UINavigationController?
    private let service = AccountService(with: Authenticator.default)

    var controller: UIViewController {
        return presenter
    }

    var mainTabBar: MainTabBarController? {
        return (presenter.tabBarController as? MainTabBarController)
    }

    init(presenter: UINavigationController) {
        self.presenter = presenter
        super.init()

        self.start()
    }

    func start() {
        presenter.delegate = self

        let jobService = JobService()
        let inquiryService = InquiryService()
        let viewModel = JobsViewModel(jobService, inquiryService)
        let jobs = JobsViewController(viewModel: viewModel, delegate: self)
        jobs.tabBarItem = UITabBarItem(title: "Jobs", image: #imageLiteral(resourceName: "jobs"), tag: 0)
        jobs.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        presenter.viewControllers = [jobs]
    }
}

extension JobsCoordinator: JobsCoordinatorDelegate {

    func showSettings() {
        let child = SettingsCoordinator(presenter: presenter)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showInquiryView() {
        let jobService = JobService()
        let inquiryService = InquiryService()
        let viewModel = JobsViewModel(jobService, inquiryService)
        let inquiryViewController = InquiryViewController(viewModel: viewModel, isScheduleToken: false)
        inquiryViewController.coordinatorDelegate = self
        let viewController = makeRootViewController(inquiryViewController)
        presenter.present(viewController, animated: true, completion: nil)
    }

    func showNewDropoffView(_ viewModel: JobsViewModel, shouldPush: Bool) {
        let newDropOffViewController = NewDropOffViewController(viewModel)
        newDropOffViewController.coordinatorDelegate = self
        if shouldPush {
            modalPresenter?.pushViewController(newDropOffViewController, animated: true)
        } else {
            let viewController = makeRootViewController(newDropOffViewController)
            presenter.present(viewController, animated: true, completion: nil)
        }
    }

    func showOnBoardingWith(params: JobRequestMeta, shouldPush: Bool, shouldShowCustomerInquiryView: Bool, presenter: UIViewController?) {
        let service = JobService()
        let viewModel = OnboardViewModel(service, requestMeta: params)
        viewModel.shouldShowCustomerInquiryView = shouldShowCustomerInquiryView
        viewModel.shouldShowJobsScreenOnCreateInquiry = false
        let onboardingViewController = OnboardingViewController(viewModel)
        if shouldPush {
            modalPresenter?.pushViewController(onboardingViewController, animated: true)
        } else {
            let viewController = makeRootViewController(onboardingViewController)
            (presenter ?? self.presenter).present(viewController, animated: true, completion: nil)
        }
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }

    private func makeRootViewController(_ rootViewController: UIViewController) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.modalPresentationStyle = .fullScreen
        modalPresenter = navController
        return navController
    }
}

// MARK: UINavigationControllerDelegate
extension JobsCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

        // Check if we are pushing a new controller
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // Popping viewcontroller
        if let settingsViewController = fromViewController as? SettingsViewController {
            childDidFinish(settingsViewController.coordinator)
        }
    }
}
