//
//  ValidationLabelView.swift
//  Motorvate
//
//  Created by Nikita Benin on 14.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import SnapKit

import UIKit

private struct Constants {
    static let tickBackgroundSize: CGFloat = 24
    static let sideInset: CGFloat = 8
    
    static let validColor: UIColor = UIColor(red: 0.25, green: 0.68, blue: 0.29, alpha: 1)
    static let invalidColor: UIColor = .gray
}

class ValidationLabelView: UIView {

    // MARK: Variables
    private var isValid: Box<Bool> = Box<Bool>(false)
    
    // MARK: UI Elements
    private let tickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.validationTick()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "At least 8 characters"
        label.font = AppFont.archivo(.medium, ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setState(text: String, isValid: Box<Bool>) {
        textLabel.text = text
        self.isValid = isValid
        bind()
    }
    
    private func bind() {
        isValid.bind { [weak self] (isValid) in
            guard let strongSelf = self else { return }
            UIView.transition(with: strongSelf.textLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                strongSelf.tickImageView.tintColor = isValid ? Constants.validColor : Constants.invalidColor
                strongSelf.textLabel.textColor = isValid ? Constants.validColor : Constants.invalidColor
            }, completion: nil)
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        addSubview(tickImageView)
        addSubview(textLabel)
    }
    
    private func setupConstraints() {
        tickImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(Constants.tickBackgroundSize)
        }
        textLabel.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(Constants.tickBackgroundSize)
            make.left.equalTo(tickImageView.snp.right).offset(Constants.sideInset)
            make.right.equalToSuperview().inset(Constants.sideInset)
        }
    }
}
