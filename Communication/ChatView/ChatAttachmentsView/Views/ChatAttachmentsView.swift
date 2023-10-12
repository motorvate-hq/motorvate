//
//  ChatAttachmentsView.swift
//  Motorvate
//
//  Created by Nikita Benin on 23.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

protocol ChatAttachmentsViewDelegate: AnyObject {
    func didSelect(model: ChatAttachmentsViewModel)
}

class ChatAttachmentsView: UIView {

    // MARK: - UI Elements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChatAttachmentsIconCell.self)
        collectionView.register(ChatAttachmentsTextCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        return collectionView
    }()
    
    // MARK: - Variables
    weak var delegate: ChatAttachmentsViewDelegate?
    private var attachmentTypes: [ChatAttachmentsViewModel] = []
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(type: ChatAttachmentsViewType) {
        switch type {
        case .job:      attachmentTypes = [.onboardVehicle, .invoice, .serviceItem]
        case .inquiry:  attachmentTypes = [.depositEstimate(excludingDeposit: true), .onboardVehicle, .depositEstimate(excludingDeposit: false)]
        case .paidJob:  attachmentTypes = [.onboardVehicle, .invoice]
        }
        collectionView.reloadData()
    }
    
    // MARK: - UI Setup
    private func setView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChatAttachmentsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = attachmentTypes[indexPath.item]
        return CGSize(width: model.cellWidth, height: 55)
    }
}

// MARK: - UICollectionViewDelegate
extension ChatAttachmentsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = attachmentTypes[indexPath.item]
        delegate?.didSelect(model: model)
    }
}

// MARK: - UICollectionViewDataSource
extension ChatAttachmentsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = attachmentTypes[indexPath.item]
        switch model.cellType {
        case .icon:
            let cell: ChatAttachmentsIconCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(model: model)
            return cell
        case .text:
            let cell: ChatAttachmentsTextCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(model: model)
            return cell
        }
    }
}
