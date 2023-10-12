//
//  ChatNavigationView.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import SnapKit
import UIKit

protocol ChatNavigationViewDelegate: AnyObject {
    func handleBack()
    func handleStatus()
    func handleSubtitle()
}

private struct Constants {
    static let buttonIconsInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    static let buttonSize: CGFloat = 38
    static let subtitleOffset: CGFloat = 2
    static let titleSideInsets: CGFloat = buttonSize * 2
    static let subtitleButtonHeight: CGFloat = 16
}

class ChatNavigationView: UIView {

    // MARK: UI Elements
    private let backButton: UIButton = {
        let button = UIButton()
        button.imageEdgeInsets = Constants.buttonIconsInsets
        button.setImage(R.image.backbutton(), for: .normal)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = AppFont.archivo(.bold, ofSize: 19)
        return label
    }()
    private let subtitleButton: UIButton = {
        let button = UIButton()
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = AppFont.archivo(.medium, ofSize: 14)
        button.imageEdgeInsets = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 1)
        return button
    }()
    private let statusButton: ChatJobStatusButton = ChatJobStatusButton()
    
    // MARK: Variables
    weak var delegate: ChatNavigationViewDelegate?
    private var jobStatus: Job.Status?
    private var showDropDown: Bool = false
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitles(title: String?, subtitle: String?, showDropDown: Bool) {
        titleLabel.text = title
        subtitleButton.setTitle(subtitle, for: .normal)
        
        self.showDropDown = showDropDown
        
        subtitleButton.imageEdgeInsets = showDropDown ? UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 1) : .zero
        subtitleButton.setImage(showDropDown ? R.image.dropDownArrow() : nil, for: .normal)
    }
    
    func setSubtitle(subtitle: String?) {
        subtitleButton.setTitle(subtitle, for: .normal)
    }
    
    func setJobStatus(jobStatus: Job.Status) {
        self.jobStatus = jobStatus
        statusButton.setStatus(jobStatus: jobStatus)
    }
    
    // MARK: Handlers
    @objc private func handleTapBackButton() {
        delegate?.handleBack()
    }
    
    @objc private func handleTapStatusButton() {
        guard let jobStatus = jobStatus, jobStatus != .none else {
            return
        }
        delegate?.handleStatus()
    }
    
    @objc private func handleTapSubtitleButton() {
        if showDropDown {
            delegate?.handleSubtitle()
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        backButton.addTarget(self, action: #selector(handleTapBackButton), for: .touchUpInside)
        addSubview(backButton)
        addSubview(titleLabel)
        subtitleButton.addTarget(self, action: #selector(handleTapSubtitleButton), for: .touchUpInside)
        addSubview(subtitleButton)
        statusButton.addTarget(self, action: #selector(handleTapStatusButton), for: .touchUpInside)
        addSubview(statusButton)
    }
    
    private func setupConstraints() {
        snp.makeConstraints { (make) -> Void in
            make.width.equalTo(UIScreen.main.bounds.width - 20)
            make.height.equalTo(40)
        }
        backButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(Constants.buttonSize)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.titleSideInsets)
            make.right.equalToSuperview().inset(Constants.titleSideInsets)
        }
        subtitleButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.subtitleOffset)
            make.left.equalToSuperview().offset(Constants.titleSideInsets)
            make.right.equalToSuperview().inset(Constants.titleSideInsets)
            make.height.equalTo(Constants.subtitleButtonHeight)
        }
        statusButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(Constants.buttonSize)
        }
    }
}
