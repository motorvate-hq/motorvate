//
//  GuideWindow.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-12-14.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class GuidePopoverView: UIView {

    enum GuideType {
        case scan(title: String, message: String, buttonTitle: String)
    }

    // MARK: - Properties

    private let backgroundCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.bold, ofSize: 19)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.regular, ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let button = AppButton(title: "")

    private weak var target: UIViewController!

    private let guideType: GuideType
    private let callback: (() -> Void)?

    // MARK: - Init

    /// Prepares a view that will be shown above the entire view hierarchy.
    /// - Parameters:
    ///   - guideType: Interface for the view to present relevant information.
    ///   - callback: Callback for the only action button the view will have.
    ///   If the view initialized without a callback, button will act as a `removeFromParent` action.
    init(target: UIViewController, guideType: GuideType, callback: (() -> Void)? = nil) {
        self.guideType = guideType
        self.callback = callback
        self.target = target
        super.init(frame: target.view.bounds)

        backgroundColor = UIColor.black.withAlphaComponent(0.8)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private func configure() {
        addSubview(backgroundCircleView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(button)

        backgroundCircleView.layer.cornerRadius = (frame.height * 0.75) / 2
        NSLayoutConstraint.activate([
            backgroundCircleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            backgroundCircleView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            backgroundCircleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundCircleView.centerYAnchor.constraint(equalTo: centerYAnchor),

            imageView.bottomAnchor.constraint(equalTo: backgroundCircleView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: backgroundCircleView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: frame.width),
            imageView.heightAnchor.constraint(equalToConstant: frame.width),

            titleLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),

            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            button.bottomAnchor.constraint(equalTo: backgroundCircleView.bottomAnchor, constant: -60)
        ])

        switch guideType {
        case .scan(let title, let message, let buttonTitle):
            imageView.image = R.image.scanGuide()
            titleLabel.text = title
            messageLabel.text = message
            button.setTitle(buttonTitle, for: .normal)
        }

        button.configure(as: .primary)
        button.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
    }

    // MARK: - Operations

    func present() {
        target.view.addSubview(self)
        alpha = 0

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }

    func dismiss() {
        // swiftlint:disable:next multiline_arguments
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    // MARK: - Objc

    @objc private func onButtonPressed(sender: UIButton) {
        /// If the window was created without a callback, default it to be a `dismiss` action.
        guard let callback = callback else {
            dismiss()
            return
        }
        callback()
    }
}
