//
//  CommunicationAvatarView.swift
//  Motorvate
//
//  Created by Nikita Benin on 02.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import SnapKit
import UIKit

private struct Constants {
    static let cornerRadius: CGFloat = 60 / 2
    static let carTopBottomInsets: CGFloat = -20
    static let carLeftRightInsets: CGFloat = 40
}

class CommunicationAvatarView: UIView {
    
    // MARK: UI Elements
    private let shadowView: UIView = UIView()
    private let shapeView: UIView = UIView()
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.carPlaceholder()
        return imageView
    }()
    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
        setupConstraints()
    }
    
    func configure(imageUrl: URL?) {
        if let imageUrl = imageUrl {
            carImageView.loadImage(
                at: imageUrl,
                placeholder: nil,
                imageContentMode: .scaleAspectFill,
                showLoadingIndicator: false) { [weak self] (hasLoadedImage) in
                self?.placeholderImageView.isHidden = hasLoadedImage
            }
        } else {
            placeholderImageView.isHidden = false
        }
    }
    
    func cancelImageLoad() {
        carImageView.cancelImageLoad()
    }
    
    private func setView() {
        shadowView.layer.addShadow(backgroundColor: .white, shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.07), cornerRadius: 30, shadowRadius: 15, shadowOffset: .zero)
        addSubview(shadowView)
        addSubview(shapeView)
        shapeView.clipsToBounds = true
        shapeView.layer.cornerRadius = Constants.cornerRadius
        shapeView.addSubview(placeholderImageView)
        shapeView.addSubview(carImageView)
    }
    
    private func setupConstraints() {
        shadowView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        shapeView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        placeholderImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        carImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(Constants.carTopBottomInsets)
            make.left.equalToSuperview().offset(Constants.carLeftRightInsets)
            make.right.equalToSuperview().inset(-Constants.carLeftRightInsets)
            make.bottom.equalToSuperview().inset(Constants.carTopBottomInsets)
        }
    }
}
