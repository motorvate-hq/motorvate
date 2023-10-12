//
//  ScanButton.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class ScanButton: UIButton {

    // MARK: - UI Elements
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = false
        stackView.spacing = 7
        return stackView
    }()
    private let scanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let scanLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.archivo(.bold, ofSize: 16)
        return label
    }()
    
    // MARK: - Variables
    let type: ScanButtonType
    
    // MARK: - Lifecycle
    init(type: ScanButtonType) {
        self.type = type
        super.init(frame: .zero)
        
        scanImageView.image = type.image?.withRenderingMode(.alwaysTemplate)
        scanLabel.text = type.title
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = AppColor.darkYellowGreen
        layer.cornerRadius = 6

        addSubview(hStackView)
        hStackView.addArrangedSubview(scanImageView)
        hStackView.addArrangedSubview(scanLabel)
    }
    
    private func setupConstraints() {
        scanImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
    }
}
