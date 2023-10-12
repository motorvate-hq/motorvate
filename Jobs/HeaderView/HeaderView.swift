//
//  HeaderView.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-01-31.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func headerView(didSelect section: HeaderView.Section)
}

final class HeaderView: UIView {

    enum Section {
        case newInquiry, newDropOff, startOnboard
    }

    // MARK: - Properties

    private let newInquirySection = HeaderSectionView(viewModel: HeaderSectionViewModel(section: .newInquiry))
    private let newDropOffSection = HeaderSectionView(viewModel: HeaderSectionViewModel(section: .newDropOff))
    private let startOnboardSection = HeaderSectionView(viewModel: HeaderSectionViewModel(section: .startOnboard))

    weak var delegate: HeaderViewDelegate?

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private func setViews() {
        let hStackView = UIStackView(arrangedSubviews: [newInquirySection,
                                                        newDropOffSection,
                                                        startOnboardSection])
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 8

        addSubview(hStackView)

        hStackView.fillSuperView(insets: UIEdgeInsets(top: 8,
                                                      left: 8,
                                                      bottom: 8,
                                                      right: 8))

        let inquiryTap = UITapGestureRecognizer(target: self, action: #selector(onNewInquiryTapped))
        newInquirySection.addGestureRecognizer(inquiryTap)
        let newDropOffTap = UITapGestureRecognizer(target: self, action: #selector(onNewDropOffTapped))
        newDropOffSection.addGestureRecognizer(newDropOffTap)
        let startOnboardTap = UITapGestureRecognizer(target: self, action: #selector(onStartOnboardTapped))
        startOnboardSection.addGestureRecognizer(startOnboardTap)
    }

    @objc private func onNewInquiryTapped() {
        delegate?.headerView(didSelect: .newInquiry)
    }
    @objc private func onNewDropOffTapped() {
        delegate?.headerView(didSelect: .newDropOff)
    }
    @objc private func onStartOnboardTapped() {
        delegate?.headerView(didSelect: .startOnboard)
    }
}
