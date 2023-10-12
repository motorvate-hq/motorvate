//
//  WalkthroughProgressView.swift
//  Motorvate
//
//  Created by Nikita Benin on 04.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let viewHeight: CGFloat = 16
    static let lineHeight: CGFloat = 4
}

class WalkthroughProgressView: UIView {

    // MARK: UI Elements
    private let progressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2.5
        
        for step in WalkthroughStep.allCases {
            let stepLineView = UIView()
            stepLineView.layer.cornerRadius = Constants.lineHeight / 2
            stepLineView.backgroundColor = UIColor(red: 0.106, green: 0.204, blue: 0.808, alpha: 1)
            stackView.addArrangedSubview(stepLineView)
        }
        
        return stackView
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
    
    func updateProgressBar(step: WalkthroughStep) {
        for index in 0..<progressStackView.arrangedSubviews.count {
            let view = progressStackView.arrangedSubviews[index]
            view.alpha = index <= step.rawValue ? 1 : 0
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        layer.cornerRadius = 6
        backgroundColor = .white
        addSubview(progressStackView)
    }
    
    private func setupConstraints() {
        snp.makeConstraints { (make) -> Void in
            make.height.equalTo(Constants.viewHeight)
        }
        progressStackView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(6)
            make.right.equalToSuperview().inset(6)
            make.height.equalTo(Constants.lineHeight)
        }
    }
}
