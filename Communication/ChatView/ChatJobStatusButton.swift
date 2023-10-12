//
//  ChatJobStatusButton.swift
//  Motorvate
//
//  Created by Nikita Benin on 25.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let buttonIconsInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    static let buttonSize: CGFloat = 38
    static let colorViewSize: CGFloat = buttonSize - buttonIconsInsets.top * 2
}

class ChatJobStatusButton: UIButton {

    // MARK: UI Elements
    private let colorView: UIView = UIView()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    func setStatus(jobStatus: Job.Status) {
        switch jobStatus {
        case .completed:
            iconImageView.image = R.image.jobStatusCompleted()
            colorView.backgroundColor = UIColor(red: 0.356, green: 0.567, blue: 0.017, alpha: 1)
        case .inqueue:
            iconImageView.image = R.image.jobStatusInQueue()
            colorView.backgroundColor = UIColor(red: 0.944, green: 0.32, blue: 0.311, alpha: 1)
        case .inProgress:
            iconImageView.image = R.image.jobStatusInProgress()
            colorView.backgroundColor = UIColor(red: 1, green: 0.683, blue: 0.076, alpha: 1)
        case .none:
            iconImageView.image = nil
            colorView.backgroundColor = .clear
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        colorView.isUserInteractionEnabled = false
        colorView.layer.cornerRadius = Constants.colorViewSize / 2
        addSubview(colorView)
        colorView.addSubview(iconImageView)
    }
    
    private func setupConstraints() {
        colorView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.colorViewSize)
        }
        iconImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5)
        }
    }
}
