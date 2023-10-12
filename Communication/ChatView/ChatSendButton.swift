//
//  ChatSendButton.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class ChatSendButton: UIButton {
    
    static let size = CGSize(width: 40, height: 49)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setImage(R.image.sendMessage(), for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
}
