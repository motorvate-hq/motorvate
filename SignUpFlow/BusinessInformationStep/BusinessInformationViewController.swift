//
//  BusinessInformationViewController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-07.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

private let dummyData = [
    "Wrapping and Detailing",
    "Mechanical Repair",
    "Collision Repair",
    "Tuning and Performance Parts",
    "Car Wash",
    "Express Services"
]

private let reuseIdentifier = "typeOfServiceCell"
private let headerIdentifier = "headerIdentifier"
private let footerIdentifier = "footerIdentifier"

final class BusinessInformationViewController: UIViewController, SBInstantiable {

    static let storyboardName = "BusinessInformation"

    // MARK: - Properties
    @IBOutlet private var collectionView: UICollectionView!
    weak var delegate: GetStartedViewControllerDelegate?
    var viewModel: AccountViewModel?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        registerNotifications()
    }
    
    // MARK: UI Setup
    private func setView() {
        collectionView.clipsToBounds = false
        collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .interactive

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .init(width: 200, height: 50)
            layout.minimumInteritemSpacing = 16
            layout.headerReferenceSize = .init(width: collectionView.frame.size.width, height: 50)
            layout.sectionInset = .init(top: 10, left: 0, bottom: 0, right: 0)
            layout.footerReferenceSize = .init(width: collectionView.frame.size.width, height: 230)
        }

        collectionView.register(TypeOfServiceCell.self)
        collectionView.register(BusinessInformationHeaderView.self, supplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(BusinessInformationFooterView.self, supplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
    }

    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        collectionView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc func keyboardWillHide() {
        collectionView.contentInset = .zero
    }
}

// MARK: - CollectionViewDelegate
extension BusinessInformationViewController: UICollectionViewDelegate {}

// MARK: - CollectionViewDataSource
extension BusinessInformationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header: BusinessInformationHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, indexPath: indexPath)
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer: BusinessInformationFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, indexPath: indexPath)
            footer.delegate = self
            return footer
        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TypeOfServiceCell = collectionView.dequeueReusableCell(for: indexPath)
        let type = dummyData[indexPath.item]
//        if indexPath.row == 6 {
//            cell.configure(as: .editable, title: type )
//        } else {
            cell.configure(as: .fixed, title: type)
//        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        update(with: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        update(with: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }

    private func update(with indexPath: IndexPath) {
        let type = dummyData[indexPath.item]
        viewModel?.update(service: type)
    }
}

// MARK: - BusinessInformationFooterViewDelegate
extension BusinessInformationViewController: BusinessInformationFooterViewDelegate {
    func didPressNextButton(businessName: String?, businessAddress: String?) {
        func _alphanumeric(for name: String) -> String {
            name.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        }

        guard let name = businessName, !name.isEmpty else {
            BaseViewController.presentAlert(message: "Please Enter a Business Name", from: self)
            return
        }
        
        guard let businessAddress = businessAddress, !businessAddress.isEmpty else {
            BaseViewController.presentAlert(message: "Please Enter a Business Address", from: self)
            return
        }

        let businessName = _alphanumeric(for: name)
        viewModel?.setParams(["businessName": businessName, "businessAddress": businessAddress])
        
        let settings = UserSettings()
        guard let userIdentifier = UserSession.shared.userID else { return }

        setAsLoading(true)
        viewModel?.createShop(userIdentifier: userIdentifier, deviceToken: settings.deviceToken ?? "tempToken")
    }
}

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        layoutAttributes?.forEach { layoutAttribute in

            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }

            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return layoutAttributes
    }
}
