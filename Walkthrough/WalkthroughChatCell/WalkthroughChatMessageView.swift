//
//  WalkthroughChatMessageView.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class WalkthroughChatMessageView: UIView {

    // MARK: UI Elements
    private let messageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.086, green: 0.22, blue: 0.569, alpha: 1)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1).cgColor
        return view
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Please follow this link to confirm job details https://stage.motorvate.app/?key=2kxSFtX3OCSgqTKTGcOd"
        label.numberOfLines = 0
        return label
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
        addSubview(messageView)
        messageView.addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        messageView.snp.makeConstraints { (make) -> Void in
            make.top.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(50)
        }
        messageLabel.snp.makeConstraints { (make) -> Void in
            make.top.left.equalToSuperview().offset(14)
            make.bottom.right.equalToSuperview().inset(14)
        }
    }

}
