//
//  RightBottomArrowCommentView.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let arrowSize = CGSize(width: 81, height: 60)
}

class RightBottomArrowCommentView: UIView {
    
    // MARK: UI Elements
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.walkthroughArrow()
        imageView.transform = .init(scaleX: -1, y: -1)
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
        }
        arrowImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(30)
            make.left.equalTo(commentLabel.snp.right).inset(-5)
            make.right.equalToSuperview()
            make.size.equalTo(Constants.arrowSize)
        }
    }
}
