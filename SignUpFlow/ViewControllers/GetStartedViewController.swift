//
//  GetStartedViewController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-07.
//  Copyright © 2019 motorvate. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

protocol GetStartedViewControllerDelegate: AnyObject {
    func createAccountButtonPressed()
    func signInButtonPressed()
    func userAuthenticated(with state: AuthState)
    func showBusinessInfo(with viewModel: AccountViewModel?)
    func confirmAccount(with credentials: Authenticator.Credentials?)
    func confirmForgotPassword(for email: String)
}

final class GetStartedViewController: UIViewController {
    fileprivate enum Constants {
        static let imageViewTopPadding: CGFloat = 50
        static let infoLabelTopPadding: CGFloat = 45
        static let infoLabelText = "Happier customers and a more organized operation for your auto service business."
        static let infoLabelSize: CGSize = CGSize(width: 305, height: 80)
        static let buttonContainerHeight: CGFloat = 50
        static let buttonContainerTopPadding: CGFloat = -10
    }

    private lazy var welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(imageLiteralResourceName: "welcome")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: AppFont.archivo(.semiBold, ofSize: 17.3),
            .paragraphStyle: paragraphStyle
        ]
        let attributedString = NSMutableAttributedString(string: Constants.infoLabelText, attributes: attributes)
        label.attributedText = attributedString
        return label
    }()

    private lazy var getStartedButton: UIButton = {
        let button = AppButton(title: "Get started")
        button.configure(as: .primary)
        button.addTarget(self, action: #selector(onGetStartedPressed), for: .touchUpInside)
        return button
    }()

    private lazy var logInButton: UIButton = {
        let button = AppButton(title: "Log in")
        button.configure(as: .passive)
        button.addTarget(self, action: #selector(onLogInPressed), for: .touchUpInside)
        return button
    }()

    weak var delegate: GetStartedViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavigationBar()
        configureSubsviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    @objc private func onGetStartedPressed() {
        delegate?.createAccountButtonPressed()
    }

    @objc private func onLogInPressed() {
        delegate?.signInButtonPressed()
    }
}

private extension GetStartedViewController {
    private func setNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.backgroundColor = .white
        navigationBar?.isTranslucent = false
        navigationBar?.shadowImage = UIImage()
    }

    private func configureSubsviews() {
        let height = view.bounds.height * 0.55
        view.addSubview(welcomeImageView)
        NSLayoutConstraint.activate([
            welcomeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.imageViewTopPadding),
            welcomeImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            welcomeImageView.heightAnchor.constraint(equalToConstant: height)
        ])

        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: welcomeImageView.bottomAnchor, constant: Constants.infoLabelTopPadding),
            infoLabel.heightAnchor.constraint(equalToConstant: Constants.infoLabelSize.height),
            infoLabel.widthAnchor.constraint(equalToConstant: Constants.infoLabelSize.width),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        let buttonContainer = UIStackView(arrangedSubviews: [getStartedButton, logInButton])
        buttonContainer.alignment = .center
        buttonContainer.spacing = 16
        buttonContainer.axis = .horizontal
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonContainer)
        NSLayoutConstraint.activate([
            buttonContainer.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 45),
            buttonContainer.heightAnchor.constraint(equalToConstant: Constants.buttonContainerHeight),
            buttonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
