//
//  WalkthroughJobStatusView.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let backgroundCornerRadius: CGFloat = 20
    static let cellHeight: CGFloat = 60
}

class WalkthroughJobStatusView: UIView {
    
    // MARK: UI Elements
    private let backgroundBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.backgroundCornerRadius
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Current Status"
        label.font = AppFont.archivo(.bold, ofSize: 19)
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        return label
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = -4
        return stackView
    }()
    
    // MARK: Variables
    private var didTapCompleted: (() -> Void)?
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTapAction(didTapCompleted: (() -> Void)?) {
        self.didTapCompleted = didTapCompleted
    }
    
    @objc private func handleCompletedTap() {
        didTapCompleted?()
    }
    
    // MARK: UI Setup
    private func setView() {
        addSubview(backgroundBackView)
        backgroundBackView.addSubview(titleLabel)
        for status in JobStatusCellModel.allCases {
            let cell = JobStatusCell()
            cell.setCell(model: status)
            cell.alpha = status == .completed ?  1 : 0.3

            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCompletedTap))
            cell.addGestureRecognizer(tapRecognizer)
            
            stackView.addArrangedSubview(cell)
        }
        backgroundBackView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        backgroundBackView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview()
        }
        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.cellHeight * 3)
            make.bottom.equalToSuperview().inset(Constants.backgroundCornerRadius)
        }
    }
}
