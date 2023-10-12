//
//  ChatAttachmentsTextCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 23.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let innerInset: CGFloat = 10
    static let imageSize: CGFloat = 44
}

class ChatAttachmentsTextCell: UICollectionViewCell, ReusableView {
    
    // MARK: - UI Elements
    private let imageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.semiBold, ofSize: 15)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(model: ChatAttachmentsViewModel) {
        imageView.image = model.icon
        titleLabel.text = model.title
        
        if let iconSize = model.iconSize {
            imageView.snp.updateConstraints { (make) -> Void in
                make.size.equalTo(iconSize)
            }
        }
    }
    
    // MARK: - UI Setup
    private func setView() {
        layer.addShadow(
            backgroundColor: .white,
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 4.5,
            shadowRadius: 5,
            shadowOffset: CGSize(width: 0, height: 1)
        )
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(Constants.innerInset)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.imageSize)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(imageView.snp.right).offset(Constants.innerInset)
            make.right.equalToSuperview().inset(Constants.innerInset)
            make.centerY.equalToSuperview()
        }
    }
}
