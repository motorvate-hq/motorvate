//
//  JobStatusCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let topInset: CGFloat = 1
    static let bottomInset: CGFloat = 12
    static let sideInset: CGFloat = 9
}

// MARK: ReusableView
extension JobStatusCell: ReusableView { }

class JobStatusCell: UITableViewCell {

    // MARK: UI Elements
    private let backgroundColorView: UIView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.archivo(.semiBold, ofSize: 16.7)
        return label
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    func setCell(model: JobStatusCellModel) {
        selectionStyle = .none
        
        backgroundColorView.layer.addShadow(backgroundColor: model.backgroundColor, shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11), cornerRadius: 5, shadowRadius: 9, shadowOffset: CGSize(width: 0, height: 4))
        backgroundColorView.layer.borderWidth = 0.83
        backgroundColorView.layer.borderColor = UIColor(red: 0.948, green: 0.948, blue: 0.948, alpha: 1).cgColor
        
        titleLabel.text = model.title
        titleLabel.textColor = model.titleColor
        iconImageView.image = model.icon
        
        iconImageView.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(model.iconSideInset)
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        addSubview(backgroundColorView)
        backgroundColorView.addSubview(titleLabel)
        backgroundColorView.addSubview(iconImageView)
    }
    
    private func setupConstraints() {
        backgroundColorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.topInset)
            make.left.equalToSuperview().offset(Constants.sideInset)
            make.right.equalToSuperview().inset(Constants.sideInset)
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset( 15 )
        }
    }
}
