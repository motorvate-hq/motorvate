//
//  WalkthroughJobCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class WalkthroughJobCell: UICollectionViewCell, ReusableView {
    
    // MARK: UI Elements
    private let jobCell = JobCell()
    private let jobCoverView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        return view
    }()
    private let statusView = WalkthroughJobStatusView()
    private let tapJobDetailsCommentView = LeftArrowCommentView(text: "\nTap on the job to\nsee job details.")
    private let tapSendMessageCommentView = LeftArrowCommentView(text: "Tap messages to\nrequest payments\nand keep your\ncustomers updated.")
    private let tapStatusCommentView = RightArrowCommentView(text: "Update the status\nto keep your entire\nshop in sync on\nyour jobs")
    private let tapCompletedCommentView = RightBottomArrowCommentView(text: "Choose “completed” to\nfinish job. Once completed,\nthe job will appear in\nCustomers.")
    
    // MARK: Variables
    private var step: Box<WalkthroughStep>?
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(step: Box<WalkthroughStep>) {
        self.step = step
        bind(step: step.value)
    }
    
    private func bind(step: WalkthroughStep?) {
        tapJobDetailsCommentView.alpha = 0
        tapSendMessageCommentView.alpha = 0
        tapStatusCommentView.alpha = 0
        tapCompletedCommentView.alpha = 0
        
        guard let step = step else { return }
        switch step {
        case .scanVin:
            jobCell.disableButtons(sendMessage: true, status: true)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.jobCoverView.alpha = 0
                self?.tapJobDetailsCommentView.alpha = 1
            })
        case .tapMessages:
            jobCell.disableButtons(sendMessage: false, status: true)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.jobCoverView.alpha = 0
                self?.tapSendMessageCommentView.alpha = 1
            })
        case .updateStatus:
            jobCell.disableButtons(sendMessage: true, status: false)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.jobCoverView.alpha = 0
                self?.statusView.transform = .init(translationX: 0, y: 400)
            })
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.tapStatusCommentView.alpha = 1
            })
        case .finishTutorial:
            jobCell.disableButtons(sendMessage: true, status: true)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.statusView.transform = .init(translationX: 0, y: 0)
            })
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.jobCoverView.alpha = 1
                self?.tapCompletedCommentView.alpha = 1
            })
        default: break
        }
    }
    
    @objc private func handleJobsTap() {
        if let step = step, step.value == .scanVin {
            step.value = .updateJobDetails
        }
    }
    
    // MARK: UI Setup
    private func setView() {
        jobCell.clipsToBounds = true
        jobCell.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleJobsTap))
        jobCell.addGestureRecognizer(tapRecognizer)
        contentView.addSubview(jobCell)
        contentView.addSubview(jobCoverView)
        jobCell.configure(for: Job.walkthroughJob)
        
        statusView.transform = .init(translationX: 0, y: 400)
        statusView.setTapAction { [weak self] in
            self?.step?.value = .closeTutorial
        }
        contentView.addSubview(statusView)
        contentView.addSubview(tapJobDetailsCommentView)
        contentView.addSubview(tapSendMessageCommentView)
        contentView.addSubview(tapStatusCommentView)
        tapCompletedCommentView.backgroundColor = .red
        contentView.addSubview(tapCompletedCommentView)
    }
    
    private func setupConstraints() {
        jobCell.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(safeArea.top).offset(220)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(JobCell.cellHeight + 15)
        }
        jobCoverView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(jobCell.snp.edges)
        }
        statusView.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalToSuperview()
        }
        tapJobDetailsCommentView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(jobCell.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
        }
        tapSendMessageCommentView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(jobCell.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(76)
            make.right.equalToSuperview()
        }
        tapStatusCommentView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(jobCell.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(56)
        }
        tapCompletedCommentView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(statusView.snp.top).inset(-114)
            make.right.equalToSuperview().inset(35)
        }
    }
}

// MARK: JobCellDelegate
extension WalkthroughJobCell: JobCellDelegate {
    func jobCell(_ jobCell: JobCell, didSelectButton type: JobCellButtonType, job: Job?) {
        switch type {
        case .message:
            if let step = step, step.value == .tapMessages {
                step.value = .sendInvoice
            }
        case .status:
            if let step = step, step.value == .updateStatus {
                step.value = .finishTutorial
                bind(step: step.value)
            }
        }
    }
}
