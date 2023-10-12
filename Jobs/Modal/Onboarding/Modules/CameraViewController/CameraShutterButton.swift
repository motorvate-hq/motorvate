//
//  CameraShutterButton.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let shutterButtonSize: CGFloat = 80
    static let shutterCircleSize: CGFloat = 56
}

class CameraShutterButton: UIButton {
    
    // MARK: - UI Elements
    private let circleView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.shutterCircleSize / 2
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        layer.cornerRadius = Constants.shutterButtonSize / 2
        layer.borderWidth = 5
        layer.borderColor = UIColor.white.cgColor
        
        addSubview(circleView)
    }
    
    private func setupConstraints() {
        snp.makeConstraints { make in
            make.size.equalTo(Constants.shutterButtonSize)
        }
        circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.shutterCircleSize)
        }
    }
}
