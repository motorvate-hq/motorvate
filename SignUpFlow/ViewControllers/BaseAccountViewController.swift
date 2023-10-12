//
//  BaseAccountViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 1/24/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation
import UIKit

class BaseAccountViewController: UIViewController {

    lazy var containerView: UIView = {
         let container = UIView()
         container.backgroundColor = .clear
         container.translatesAutoresizingMaskIntoConstraints = false
         return container
     }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
}
