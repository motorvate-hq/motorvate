//
//  HeaderSectionView.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-01-31.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

final class HeaderSectionView: UIView {

    // MARK: - Properties

    let imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.bold, ofSize: 13)
        label.textAlignment = .center
        return label
    }()

    private var viewModel: HeaderSectionViewModel

    // MARK: - Init

    init(viewModel: HeaderSectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private func setViews() {
        imageContainer.addSubview(imageView)
        addSubview(imageContainer)
        addSubview(label)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: viewModel.section == .startOnboard ? 36 : 23),
            imageView.widthAnchor.constraint(equalToConstant: viewModel.section == .startOnboard ? 36 : 23),
            imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),

            imageContainer.heightAnchor.constraint(equalToConstant: 42),
            imageContainer.widthAnchor.constraint(equalToConstant: 42),
            imageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),

            label.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 7),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        layer.cornerRadius = 4.4
        label.text = viewModel.title
        imageContainer.layer.cornerRadius = 21

        switch viewModel.section {
        case .newInquiry:
            backgroundColor = R.color.c1B34CE()?.withAlphaComponent(0.21)
            imageContainer.backgroundColor = R.color.c0D279A()
            imageView.image = R.image.headerSendForms()
        case .newDropOff:
            backgroundColor = R.color.cFFAE13()?.withAlphaComponent(0.21)
            imageContainer.backgroundColor = R.color.cFFAE13()
            imageView.image = R.image.iconCalendar()
        case .startOnboard:
            backgroundColor = R.color.c5B9104()?.withAlphaComponent(0.21)
            imageContainer.backgroundColor = R.color.c5B9104()
            imageView.image = R.image.headerOnboardVehicle()
        }
    }
}
