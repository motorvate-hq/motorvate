//
//  SubscriptionSuccessViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 2/20/23.
//  Copyright © 2023 motorvate. All rights reserved.
//

import UIKit

struct SubscriptionSuccessViewModel {

}

final class SubscriptionSuccessViewController: UIViewController {
    private let viewModel: SubscriptionViewModel

    init(viewModel: SubscriptionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAndConstrainView()
    }
}

// MARK: - Private
extension SubscriptionSuccessViewController {
    private func configureAndConstrainView() {

    }
}
