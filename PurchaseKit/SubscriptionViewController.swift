//
//  SubscriptionViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 9/4/22.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Combine
import Foundation
import UIKit
import SwiftUI

// MARK: - SubscriptionViewControllerDelegate
protocol SubscriptionViewControllerDelegate: AnyObject {
    func didCompletePurchase()
}

extension SubscriptionViewController {
    enum State {
        case fetchProduct(PurchaseKit.EntitlementTier)
        case productsFetched
        case purchaseSuccess
    }
}

final class SubscriptionViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    weak var delegate: SubscriptionViewControllerDelegate?

    private enum Constants {
        static let buttonSize = CGSize(width: 20, height: 20)
        static let disclaimerText = "Billing begins when your free trial ends. Cancel before your free trial ends and you won't be charged. Subscription automatically renews until you cancel. Cancel anytime in your Apple ID settings."

        static let message = "Terms of use | Privacy policy"
        static let freeTrialPriceDisclaimer = "Try 7 Days free, then %@/month"
        static let priceDisclaimer = "Try 7 Days free, then $%@/month"
        static let subtitle = "Instantly improve the customer experience for your shop or mobile service 🚗💨"
        static let headerTitle = "AUTOMATED SCHEDULING TO REDUCE NO SHOWS"
    }

    private lazy var priceDisclaimerLabel: UILabel = Self.makeLabel(using: AppFont.archivo(.semiBold, ofSize: 17), text: "")

    private lazy var stackScrollView: StackScrollView = {
        let stackScrollView = StackScrollView(contentEdgeInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        stackScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackScrollView.backgroundColor = .systemBackground
        stackScrollView.setSpacing(20)
        return stackScrollView
    }()

    private lazy var subscribeButton: UIButton = {
        let button = AppButton(title: "")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(as: .primary)
        button.setFont(font: UIFont.boldSystemFont(ofSize: 17))
        button.addTarget(self, action: #selector(didPressSubscribebutton), for: .touchUpInside)
        return button
    }()

    private lazy var restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore purchase", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didPressRestorebutton), for: .touchUpInside)
        return button
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .right
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.linkTextAttributes = [
            .foregroundColor: R.color.c1B34CE() ?? .blue
        ]
        return textView
    }()

    let viewModel: SubscriptionViewModel

    init(viewModel: SubscriptionViewModel = SubscriptionViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bindModel()
        render(state: .fetchProduct(.base))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCloseButton()
    }
    
    func setupCloseButton() {
        guard self.presentingViewController != nil else { return }
        
        let backItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didPressCloseButton))
        navigationItem.rightBarButtonItem = backItem
    }
}

extension SubscriptionViewController {
    private func bindModel() {
        viewModel.$products
            .dropFirst()
            .sink { [weak self] _ in
                self?.render(state: .productsFetched)
            }.store(in: &cancellables)

        viewModel.$transactionResult
            .dropFirst()
            .sink { [weak self] _ in
                self?.handleTransactionResult()
            }.store(in: &cancellables)
    }

    private func configure() {
        view.backgroundColor = .systemBackground

        view.addSubview(stackScrollView)
        NSLayoutConstraint.activate([
            stackScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        stackScrollView.contentInset.top = 10

//        let logoImageView = UIImageView(image: UIImage(named: "logo"))
//        logoImageView.contentMode = .scaleAspectFit
//        stackScrollView.insertView(logoImageView)
//        logoImageView.constraintSize(CGSize(width: 220, height: 25))
        
        let headerLabel = Self.makeLabel(using: AppFont.archivo(.bold, ofSize: 20), text: Constants.headerTitle)
        stackScrollView.insertView(headerLabel)

        let subHeaderLabel = Self.makeLabel(using: AppFont.archivo(.semiBold, ofSize: 18), text: Constants.subtitle)
        stackScrollView.insertView(subHeaderLabel)

        let groupInfoView = Self.makeGroupedView()
        stackScrollView.insertView(groupInfoView)

//        let priceDisclaimer = Self.makeLabel(using: AppFont.archivo(.semiBold, ofSize: 16), text: "")
        stackScrollView.insertView(priceDisclaimerLabel)
        stackScrollView.customSpacing(12, after: priceDisclaimerLabel)

        stackScrollView.insertView(subscribeButton)
        NSLayoutConstraint.activate([ subscribeButton.heightAnchor.constraint(equalToConstant: 50) ])

        let disclaimerLabel = Self.makeLabel(using: AppFont.archivo(ofSize: 13), text: Constants.disclaimerText)
        disclaimerLabel.textColor = R.color.c666666()
        stackScrollView.insertView(disclaimerLabel)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        stackScrollView.insertView(restoreButton)
        NSLayoutConstraint.activate([ restoreButton.heightAnchor.constraint(equalToConstant: 30) ])

        stackScrollView.insertView(textView)
        let attributedString = NSMutableAttributedString(string: Constants.message, attributes: [.paragraphStyle: style])
        let ppRange = NSString(string: Constants.message).range(of: "Privacy policy", options: .caseInsensitive)
        let tosRange = NSString(string: Constants.message).range(of: "Terms of use", options: .caseInsensitive)
        if ppRange.location != NSNotFound && tosRange.location != NSNotFound {
            attributedString.addAttribute(.link, value: URL(string: "www.google.com") as Any, range: ppRange)
            attributedString.addAttribute(.link, value: URL(string: "www.google.com") as Any, range: tosRange)
            textView.attributedText = attributedString
        }
    }

    @objc private func didPressCloseButton() {
        dismiss(animated: true)
    }

    @objc private func didPressSubscribebutton() {
        guard !SubscriptionViewModel.isDebugMode else {
            UserSettings().isEntitledToBaseSubscriptionInDebugMode = true
            render(state: .purchaseSuccess)
            return
        }
        viewModel.purchase()
    }

    @objc private func didPressRestorebutton() {
        guard !SubscriptionViewModel.isDebugMode else {
            UserSettings().isEntitledToBaseSubscriptionInDebugMode = true
            render(state: .purchaseSuccess)
            return
        }
        viewModel.restorePurchase()
    }
}

extension SubscriptionViewController {
    func render(state: State) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            switch state {
            case let .fetchProduct(entitlement):
                self.handleFetchProducts(for: entitlement)
            case .productsFetched:
                self.handleFetchedProduct()
            case .purchaseSuccess:
                if self.presentingViewController != nil {
                    self.dismiss(animated: true) { [weak self] in
                        self?.delegate?.didCompletePurchase()
                    }
                } else {
                    self.delegate?.didCompletePurchase()
                }
            }
        }
    }

    private func handleTransactionResult() {
        DispatchQueue.main.async {
            let value = self.viewModel.transactionResult
            switch value {
            case .success:
                self.render(state: .purchaseSuccess)
            case .error(let string):
                self.presentAlert(message: string)
            case .cancelled, .unkown:
                MLogger.log(.info, "Do nothing")
            }
        }
    }

    private func handleFetchProducts(for entitlement: PurchaseKit.EntitlementTier) {
        viewModel.fetchProducts(entitlement)
    }

    private func handleFetchedProduct() {
        let productInfo = viewModel.productInfo

        subscribeButton.isEnabled = productInfo?.localizedPriceString != nil
        subscribeButton.setTitle(buttonTitle(from: productInfo), for: .normal)
        priceDisclaimerLabel.text = disclaimerText(from: productInfo)
    }

    private func buttonTitle(from productInfo: ProductInfo?) -> String {
        if productInfo?.localizedIntroductoryPrice != nil {
            return NSLocalizedString("Start your free trial", comment: "")
        }

        if let price = productInfo?.localizedPriceString {
            return NSLocalizedString("Subscribe for \(price)", comment: "")
        }

        return NSLocalizedString("Not avialable in debug", comment: "")
    }

    private func disclaimerText(from productInfo: ProductInfo?) -> String {
        if productInfo?.localizedIntroductoryPrice != nil, let price = productInfo?.localizedPriceString {
            let formattedString = String(format: Constants.freeTrialPriceDisclaimer, price)
            return NSLocalizedString(formattedString, comment: "")
        }

        return NSLocalizedString("", comment: "")
    }


    private static func makeLabel(using font: UIFont, text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = text
        label.font = font
        label.textAlignment = .center
        return label
    }

    private static func makeGroupedView() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .equalSpacing

        let icon = R.image.greenCheck()
        for message in ["Real time updates of your shops availability when customers text your new virtual number", "Co-Branded forms of your shop name & address", "Confirm or decline customer service requests times with one tap",  "Automated text for confirmation and reminders of scheduled service sent to your customers phone prior to service"]  {
            stack.addArrangedSubview(IconLabelView(icon: icon, text: message))
        }
        return stack
    }
}

// MARK: UITextViewDelegate
extension SubscriptionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
