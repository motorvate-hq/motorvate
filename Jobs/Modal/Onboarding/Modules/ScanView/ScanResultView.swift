//
//  ScanResultView.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class ScanResultView: UIView {

    // MARK: - UI Elements
    private let scanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let scanResultLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.bold, ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(type: ScanButtonType, value: String) {
        scanImageView.image = type.image?.withRenderingMode(.alwaysTemplate)
        scanResultLabel.text = value
    }
    
    // MARK: - Setup UI
    private func setupView() {
        addSubview(scanImageView)
        addSubview(scanResultLabel)
    }
    
    private func setupConstraints() {
        scanImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }
        scanResultLabel.snp.makeConstraints { make in
            make.top.equalTo(scanImageView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
