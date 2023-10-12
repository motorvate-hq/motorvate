//
//  ChatJobSelectorCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let carImageSize: CGFloat = 60
    static let topBottomOffset: CGFloat = 7
    static let sideInset: CGFloat = 15
}

// MARK: ReusableView
extension ChatJobSelectorCell: ReusableView { }

class ChatJobSelectorCell: UITableViewCell {
    
    // MARK: Static properties
    static let cellHeight: CGFloat = Constants.carImageSize + Constants.topBottomOffset * 2

    // MARK: UI Elements
    private let carImageView: CommunicationAvatarView = CommunicationAvatarView()
    private let carTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = AppFont.archivo(.bold, ofSize: 16)
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        carImageView.cancelImageLoad()
    }
    
    func configure(model: ChatJobSelectorCellModel) {
        carTitleLabel.text = model.carTitle
        carImageView.configure(imageUrl: model.imageURL)
    }
    
    // MARK: UI Setup
    private func setView() {
        selectionStyle = .none
        addSubview(carImageView)
        addSubview(carTitleLabel)
    }
    
    private func setupConstraints() {
        carImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.sideInset)
            make.size.equalTo(Constants.carImageSize)
        }
        carTitleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(Constants.topBottomOffset)
            make.left.equalTo(carImageView.snp.right).offset(Constants.sideInset)
            make.right.equalToSuperview().inset(Constants.sideInset)
            make.bottom.equalToSuperview().inset(Constants.topBottomOffset)
        }
    }
}
