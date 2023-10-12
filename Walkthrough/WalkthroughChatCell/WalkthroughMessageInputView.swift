//
//  WalkthroughMessageInputView.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class WalkthroughMessageInputView: UIView {
    
    // MARK: UI Elements
    private let innerView = UIView()
    private let inputLabelView: UILabel = {
        let label = UILabel()
        label.text = "  Type in your message…"
        label.textColor = .gray
        label.font = AppFont.archivo(.medium, ofSize: 14)
        label.layer.borderWidth = 0.7
        label.layer.borderColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1).cgColor
        label.layer.addShadow(
            backgroundColor: .white,
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.03),
            cornerRadius: 4,
            shadowRadius: 6,
            shadowOffset: CGSize(width: 0, height: 1)
        )
        return label
    }()
    private let sendMessageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.sendMessage()
        return imageView
    }()
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        backgroundColor = .white
        addSubview(innerView)
        innerView.addSubview(inputLabelView)
        innerView.addSubview(sendMessageImageView)
        addSubview(coverView)
    }
    
    private func setupConstraints() {
        innerView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(safeAreaInsets.bottom + 35)
        }
        inputLabelView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(11)
            make.bottom.equalToSuperview().inset(5)
        }
        sendMessageImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalTo(inputLabelView.snp.right).inset(-9)
            make.right.equalToSuperview().inset(11)
            make.size.equalTo(28)
        }
        coverView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
