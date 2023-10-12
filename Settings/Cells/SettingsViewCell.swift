//
//  SettingsRowCell.swift
//  Motorvate
//
//  Created by Charlie on 2019-08-25.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let titleLabelLeadingOffset: CGFloat = 98
    static let separatorHeight: CGFloat = 1
}

final class SettingsViewCell: UITableViewCell, ReusableView {

    // MARK: - UI Elements
    private let icon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.semiBold, ofSize: 19)
        label.textColor = UIColor(named: "componentText")
        return label
    }()
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 1, green: 0.683, blue: 0.076, alpha: 1)
        return view
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupViews() {
        selectionStyle = .none
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(separator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLabelLeadingOffset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            separator.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(_ item: SettingItem) {
        titleLabel.text = item.stringValue
        icon.image = UIImage(imageLiteralResourceName: item.imageName)
        
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: item.imageSize.height * 1.2),
            icon.widthAnchor.constraint(equalToConstant: item.imageSize.width * 1.2),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: item.imageViewLeadingOffset)
        ])
    }
}
