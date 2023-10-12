//
//  CustomersCoordinator.swift
//  Motorvate
//
//  Created by Emmanuel on 2/12/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

class CustomersCoordinator: Coordinator {
    fileprivate let presenter: UINavigationController

    var controller: UIViewController {
        return presenter
    }

    init(presenter: UINavigationController) {
        self.presenter = presenter

        let service = JobService()
        let viewModel = CustomersViewModel(service)
        let customersViewController = CustomersViewController(viewModel: viewModel)
        customersViewController.tabBarItem = UITabBarItem(title: "Customers", image: #imageLiteral(resourceName: "customers"), tag: 3)
        customersViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        presenter.viewControllers = [customersViewController]
    }

    func start() {}
}
