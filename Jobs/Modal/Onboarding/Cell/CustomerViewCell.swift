//
//  CustomerViewCell.swift
//  Motorvate
//
//  Created by Emmanuel on 8/13/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class CustomerViewCell: UICollectionViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.isUserInteractionEnabled = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        styleComponents()
    }

    public func configure(_ viewModel: OnboardViewModel, indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath)
        fullNameLabel.text = item.customer?.fullName
        phoneNumberLabel.text = item.customer?.phoneNumber
        descriptionLabel.text = item.model
        noteLabel.text = item.note
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                styleComponent(for: true)
            } else {
                styleComponent(for: false)
            }
        }
    }
}

private extension CustomerViewCell {
    private func styleComponents() {
        layer.cornerRadius = 5
        clipsToBounds = true
    }

    private func styleComponent(for state: Bool) {
        backgroundColor = state ? AppColor.darkYellowGreen : .systemBackground
        let color = _color(for: state)
        fullNameLabel.textColor = color
        phoneNumberLabel.textColor = color
        descriptionLabel.textColor = color
        noteLabel.textColor = color
    }

    private func _color(for selectedState: Bool) -> UIColor {
        guard traitCollection.userInterfaceStyle == .light else { return .white }
        return selectedState ? .white : .black
    }
}

extension CustomerViewCell: ReusableView {}
extension CustomerViewCell: NibLoadableView {}
