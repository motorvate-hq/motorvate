//
//  WalkthroughJobDetailsCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let addServiceButtonSize = CGSize(width: 110, height: 45)
    static let fingerImageViewSize = CGSize(width: 110, height: 96)
}

class WalkthroughJobDetailsCell: UICollectionViewCell, ReusableView {
    
    // MARK: UI Elements
    private let serviceView = WalkthroughJobDetailsServiceView()
    private let commentView = BottomArrowCommentView(text: "Tap icon to add service,\npart, item or price of the\nservice information")
//    private let fingerImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = R.image.walkthroughFinger()
//        return imageView
//    }()
    private let addServiceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Service", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 15)
        button.layer.addShadow(
            backgroundColor: UIColor(red: 1, green: 0.682, blue: 0.075, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 5,
            shadowRadius: 10,
            shadowOffset: CGSize(width: 0, height: 4)
        )
        return button
    }()
    private let swipeCommentView = RightBottomArrowCommentView(text: "Each item can be\nmodifed or deleted in\nreal-time.")
    
    // MARK: Variables
    private var step: Box<WalkthroughStep>?
    private var jobDetails: ServiceDetail?
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(step: Box<WalkthroughStep>, jobDetails: ServiceDetail) {
        self.step = step
        self.jobDetails = jobDetails
        self.updateStep(walkthroughStep: step.value)
    }
    
    func updateStep(walkthroughStep: WalkthroughStep) {
        switch walkthroughStep {
        case .updateJobDetails:
            serviceView.isHidden = true
//            fingerImageView.isHidden = true
            commentView.isHidden = false
            addServiceButton.isHidden = false
            swipeCommentView.isHidden = true
        case .editJobDetails:
            if let jobDetails = jobDetails {
                serviceView.updateJobDetails(
                    jobDetail: jobDetails,
                    hasSwiped: {
//                        [weak self] in
//                        self?.fingerImageView.layer.removeAllAnimations()
//                        UIView.animate(withDuration: 1.5, delay: 0, options: [], animations: { [weak self] in
//                            self?.fingerImageView.transform = .init(translationX: 0, y: 0)
//                            self?.fingerImageView.alpha = 0
//                        }, completion: nil)
                    }
                )
            }
            serviceView.isHidden = false
//            fingerImageView.isHidden = false
            commentView.isHidden = true
            addServiceButton.isHidden = true
            swipeCommentView.isHidden = false
        default:
            break
        }
    }
    
    private func setView() {
        contentView.addSubview(serviceView)
        contentView.addSubview(commentView)
//        contentView.addSubview(fingerImageView)
        addServiceButton.addTarget(self, action: #selector(handleAddService), for: .touchUpInside)
        contentView.addSubview(addServiceButton)
        
//        fingerImageView.alpha = 1
//        UIView.animate(withDuration: 1.5, delay: 1, options: [.repeat], animations: { [weak self] in
//            self?.fingerImageView.transform = .init(translationX: -75, y: 0)
//        }, completion: nil)
        
        contentView.addSubview(swipeCommentView)
    }
    
    @objc private func handleAddService() {
        step?.value = .enterJobDetails
    }
    
    private func setupConstraints() {
        serviceView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(safeArea.top).offset(378)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
//        fingerImageView.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(serviceView.snp.bottom)
//            make.right.equalToSuperview().inset(5)
//            make.size.equalTo(Constants.fingerImageViewSize)
//        }
        commentView.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(addServiceButton.snp.left).inset(-15)
            make.bottom.equalTo(addServiceButton.snp.top).offset(Constants.addServiceButtonSize.height / 2 + 7)
        }
        addServiceButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(safeArea.bottom).inset(79)
            make.right.equalToSuperview().inset(13)
            make.size.equalTo(Constants.addServiceButtonSize)
        }
        swipeCommentView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(serviceView.snp.top).inset(-110)
            make.right.equalToSuperview().inset(50)
        }
    }
}
