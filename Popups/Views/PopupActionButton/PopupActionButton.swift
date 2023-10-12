//
//  PopupActionButton.swift
//  Motorvate
//
//  Created by Nikita Benin on 12.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class PopupActionButton: UIButton {

    // MARK: UI Elements
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .white
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    // MARK: Variables
    private var style: PopupActionButtonStyle
    
    // MARK: Lifecycle
    init(style: PopupActionButtonStyle = .blue) {
        self.style = style
        super.init(frame: .zero)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAsLoading(_ asLoading: Bool) {
        if asLoading {
            isUserInteractionEnabled = false
            titleLabel?.alpha = 0
            activityIndicatorView.startAnimating()
        } else {
            isUserInteractionEnabled = true
            titleLabel?.alpha = 1
            activityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        activityIndicatorView.color = style.textColor
        setTitleColor(style.textColor, for: .normal)
        titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 14)
        layer.addShadow(
            backgroundColor: style.backgroundColor,
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 8,
            shadowRadius: 11,
            shadowOffset: CGSize(width: 0, height: 4)
        )
        addSubview(activityIndicatorView)
    }
    
    private func setupConstraints() {
        activityIndicatorView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
    }
}
