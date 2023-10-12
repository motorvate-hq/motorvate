//
//  BottomArrowCommentView.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let arrowSize = CGSize(width: 74, height: 44)
}

class BottomArrowCommentView: UIView {
    
    // MARK: UI Elements
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.walkthroughBottomArrow()
        return imageView
    }()
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    init(text: String) {
        super.init(frame: .zero)
        
        commentLabel.text = text
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    private func setView() {
        addSubview(arrowImageView)
        addSubview(commentLabel)
    }
    
    private func setupConstraints() {
        commentLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(commentLabel.snp.bottom)
            make.right.bottom.equalToSuperview()
            make.size.equalTo(Constants.arrowSize)
        }
    }
}
