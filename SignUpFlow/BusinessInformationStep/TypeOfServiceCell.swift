//
//  TypeOfServiceCell.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-07.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

protocol TypeOfServiceCellDelegate: AnyObject {

}

private struct Constants {
    static let borderColor: CGColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1).cgColor
}

final class TypeOfServiceCell: UICollectionViewCell {

    enum CellType {
        case fixed
        case editable
    }

    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }

    // MARK: - UI
    private func insert(view: UIView) {
        addSubview(view)
        view.fillSuperView()
    }

    // MARK: - Operations
    func configure(as type: CellType, title: String? = nil) {
        clipsToBounds = false
        layer.addShadow(
            backgroundColor: UIColor.white,
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.09),
            cornerRadius: 6,
            shadowRadius: 6,
            shadowOffset: CGSize(width: 0, height: 1)
        )
        layer.borderColor = Constants.borderColor
        layer.borderWidth = 1

        switch type {
        case .fixed:
            insert(view: serviceTitle)
            serviceTitle.setTitle(title, for: .normal)
        case .editable:
            textFieldContainer.addSubview(textField)
            textField.fillSuperView(insets: .init(top: 12, left: 12, bottom: 12, right: 12))
            insert(view: textFieldContainer)
            textField.delegate = self
            textField.placeholder = title
        }
    }

    private func updateSelectedState() {
        if isSelected {
            layer.borderColor = AppColor.highlightYellow.cgColor
            backgroundColor = AppColor.highlightYellow
        } else {
            layer.borderColor = Constants.borderColor
            backgroundColor = .white
        }
    }

    // MARK: - Components
    // UIButton is used like a label to take advantage of edge insets and auto resizing.
    private let serviceTitle: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.darkText, for: .normal)
        button.contentEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
        button.isUserInteractionEnabled = false
        return button
    }()

    private let textFieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
}

// MARK: - UITextFieldDelegate
extension TypeOfServiceCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSelected = true
    }
}

extension TypeOfServiceCell: ReusableView {}
