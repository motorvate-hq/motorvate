//
//  WalkthroughAddServiceCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let addButtonSize: CGSize = CGSize(width: 95, height: 53)
}

class WalkthroughAddServiceCell: UICollectionViewCell, ReusableView {
    
    // MARK: UI Elements
    private let serviceView = WalkthroughAddServiceView()
    private let commentView = BottomArrowCommentView(text: "Each item you label is\nadded to the total price of\nthe service information")
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1), for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 16)
        button.backgroundColor = UIColor(red: 1, green: 0.683, blue: 0.076, alpha: 1)
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: Variables
    private var didTapAddService: ((ServiceDetail?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(didTapAddService: @escaping (ServiceDetail?) -> Void) {
        self.didTapAddService = didTapAddService
    }
    
    @objc private func handleAddService() {
        didTapAddService?(serviceView.getJobDetails())
    }
    
    private func setView() {
        contentView.addSubview(serviceView)
        addButton.addTarget(self, action: #selector(handleAddService), for: .touchUpInside)
        contentView.addSubview(commentView)
        contentView.addSubview(addButton)
    }
    
    private func setupConstraints() {
        serviceView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        commentView.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(addButton.snp.left).inset(-15)
            make.bottom.equalTo(addButton.snp.top).offset(Constants.addButtonSize.height / 2 + 7)
        }
        addButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(safeArea.bottom).inset(79)
            make.right.equalToSuperview().inset(25)
            make.size.equalTo(Constants.addButtonSize)
        }
    }
}
