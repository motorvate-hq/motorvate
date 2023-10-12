//
//  EstimateWalkthroughStepCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 23.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
}

class EstimateWalkthroughStepCell: UICollectionViewCell, ReusableView {
    
    // MARK: UI Elements
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let bottomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundImages(type: EstimateWalkthroughCellType) {
        if let topImage = type.backgroundTopImage {
            topImageView.image = topImage
            
            let topImageHeight = topImage.size.height / topImage.size.width * Constants.screenWidth
            topImageView.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(topImageHeight)
            }
        }
        
        if let bottomImage = type.backgroundBottomImage {
            bottomImageView.image = bottomImage
            
            let bottomImageHeight = bottomImage.size.height / bottomImage.size.width * Constants.screenWidth
            bottomImageView.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(bottomImageHeight)
            }
        }
    }
    
    // MARK: UI Setup
    private func setViews() {
        backgroundColor = .white
        contentView.addSubview(topImageView)
        contentView.addSubview(bottomImageView)
        contentView.addSubview(coverView)
    }
    
    private func setupConstraints() {
        topImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(0)
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        bottomImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        coverView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
