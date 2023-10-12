//
//  SupportButton.swift
//  Motorvate
//
//  Created by Nikita Benin on 08.04.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class SupportButton: UIButton {
    
    // MARK: - UI Elements
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.archivo(.bold, ofSize: 15)
        label.textAlignment = .center
        label.text = "Call / Text Support"
        return label
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.contactSupport()
        return imageView
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
    
    // MARK: - UI Setup
    private func setView() {
        layer.addShadow(
            backgroundColor: UIColor(red: 0.538, green: 0.538, blue: 0.538, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 6,
            shadowRadius: 5,
            shadowOffset: CGSize(width: 0, height: 5)
        )
        addSubview(label)
        addSubview(iconImageView)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        iconImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalTo(label.snp.right).inset(-10)
            make.right.equalToSuperview().inset(10)
            make.size.equalTo(23)
        }
    }
}
