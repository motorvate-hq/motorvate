//
//  ChatInputBarView.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

import InputBarAccessoryView

class ChatInputBarView: InputBarAccessoryView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        inputTextView.clipsToBounds = false
        inputTextView.placeholder = "Type in your message…"
        inputTextView.font = AppFont.archivo(.medium, ofSize: 14)
        inputTextView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        inputTextView.textContainerInset = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        inputTextView.layer.borderWidth = 0.7
        inputTextView.layer.borderColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1).cgColor
        inputTextView.layer.addShadow(
            backgroundColor: .white,
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.03),
            cornerRadius: 4,
            shadowRadius: 6,
            shadowOffset: CGSize(width: 0, height: 1)
        )
    }
    
}
