//
//  WalkthroughStepCarView.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class WalkthroughStepCarView: UIView {
    
    // MARK: UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.walkthroughCar()
        return imageView
    }()
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.439, green: 0.49, blue: 0.831, alpha: 1)
        return view
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
    
    // MARK: UI Setup
    private func setView() {        
        addSubview(backView)
        addSubview(imageView)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
            make.width.equalTo(84)
        }
        imageView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
