//
//  CommunicationCoordinator.swift
//  Motorvate
//
//  Created by Emmanuel on 2/12/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

class CommunicationCoordinator: Coordinator {
    fileprivate let presenter: UINavigationController

    var controller: UIViewController {
        return presenter
    }

    init(presenter: UINavigationController = UINavigationController()) {
        self.presenter = presenter

        let communication = CommunicationViewController()
        communication.title = "Communication"
        communication.tabBarItem = UITabBarItem(title: "Messages", image: #imageLiteral(resourceName: "communication"), tag: 2)
        communication.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        presenter.viewControllers = [communication]
    }

    func start() {}
}
