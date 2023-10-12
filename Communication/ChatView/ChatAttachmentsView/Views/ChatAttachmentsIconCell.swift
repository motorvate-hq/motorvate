//
//  ChatAttachmentsIconCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 23.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let imageSize: CGFloat = 33
}

class ChatAttachmentsIconCell: UICollectionViewCell, ReusableView {
    
    // MARK: - UI Elements
    private let imageView = UIImageView()
    
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
    }
    
    // MARK: - UI Setup
    private func setView() {
        addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.imageSize)
        }
    }
}
