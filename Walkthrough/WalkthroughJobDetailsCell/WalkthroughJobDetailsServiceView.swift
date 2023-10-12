//
//  WalkthroughJobDetailsServiceView.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
//    private static let editIconSize: CGSize = CGSize(width: 23, height: 23)
//    static let editRenderedImage = UIGraphicsImageRenderer(size: Constants.editIconSize).image { _ in
//        R.image.serviceEdit()?.draw(in: CGRect(origin: .zero, size: Constants.editIconSize))
//    }
//
//    private static let deleteIconSize: CGSize = CGSize(width: 15, height: 18)
//    static let deleteRenderedImage = UIGraphicsImageRenderer(size: Constants.deleteIconSize).image { _ in
//       R.image.serviceDelete()?.draw(in: CGRect(origin: .zero, size: Constants.deleteIconSize))
//    }
    static let buttonWidth: CGFloat = 50
}

class WalkthroughJobDetailsServiceView: UIView {
    
    // MARK: UI Elements
    private let swipeableView = UIView()
    private let stackView: UIStackView = UIStackView()
    private let serviceCell = ServiceCell()
    private let editButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
//        button.setImage(Constants.editRenderedImage, for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0.682, blue: 0.075, alpha: 0.3)
        return button
    }()
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
//        button.setImage(Constants.deleteRenderedImage, for: .normal)
        button.backgroundColor = UIColor(red: 0.944, green: 0.32, blue: 0.311, alpha: 0.3)
        return button
    }()
    
    // MARK: Variables
//    private var hasSwiped: (() -> Void)?
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateJobDetails(jobDetail: ServiceDetail, hasSwiped: @escaping (() -> Void)) {
        serviceCell.setCell(item: jobDetail)
//        self.hasSwiped = hasSwiped
    }
    
    private func setView() {
        swipeableView.clipsToBounds = true
        addSubview(swipeableView)
        
        backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        stackView.addArrangedSubview(serviceCell)
        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(deleteButton)
        swipeableView.addSubview(stackView)
        
//        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
//        leftGesture.direction = .left
//        swipeableView.addGestureRecognizer(leftGesture)
//
//        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
//        rightGesture.direction = .right
//        swipeableView.addGestureRecognizer(rightGesture)
    }
    
//    @objc private func handleSwipe(gestureRecognizer: UISwipeGestureRecognizer) {
//        if gestureRecognizer.state == .ended {
//            switch gestureRecognizer.direction {
//            case .left:
//                let translationX = -(Constants.buttonWidth * 2)
//                animateSwipe(translationX: translationX)
//            case .right:
//                stackView.transform = CGAffineTransform(translationX: 0, y: 0)
//                animateSwipe(translationX: 0)
//            default: break
//            }
//            hasSwiped?()
//        }
//    }
//
//    private func animateSwipe(translationX: CGFloat) {
//        UIView.animate(withDuration: 0.2) { [weak self] in
//            self?.stackView.transform = CGAffineTransform(translationX: translationX, y: 0)
//        }
//    }
    
    private func setupConstraints() {
        swipeableView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints { (make) -> Void in
            make.top.left.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(-(Constants.buttonWidth * 2))
        }
        editButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(Constants.buttonWidth)
        }
        deleteButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(Constants.buttonWidth)
        }
    }
}
