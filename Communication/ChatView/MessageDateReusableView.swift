//
//  MessageDateReusableView.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import MessageKit
import UIKit

private struct Constants {
    static let topOffset: CGFloat = 26
    static let sideInset: CGFloat = 10
}

class MessageDateReusableView: MessageReusableView {
        
    // MARK: UI Elements
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = AppFont.archivo(.medium, ofSize: 14)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
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
    
    func setTime(time: String) {
        timeLabel.text = time
    }
    
    func setDate(date: Date) {
        timeLabel.text = date.getMessageFormattedDateString()
    }
    
    // MARK: UI Setup
    private func setView() {
        addSubview(timeLabel)
    }
    
    private func setupConstraints() {
        timeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(Constants.topOffset)
            make.left.equalToSuperview().offset(Constants.sideInset)
            make.right.equalToSuperview().inset(Constants.sideInset)
        }
    }
}
