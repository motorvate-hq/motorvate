//
//  WalkthroughChatCell.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class WalkthroughChatCell: UICollectionViewCell, ReusableView {
    
    // MARK: UI Elements
    private let messageView = WalkthroughChatMessageView()
    private let attachmentsCell = ChatAttachmentsTextCell()
    private let messageInputView = WalkthroughMessageInputView()
    private let rightArrowCommentView = RightArrowCommentView(text: "Once sent, customers can\nconfirm the the service and\npay.\n\nYou will recieve a\nnotifcation and we email\ncopies to your shop and\ncustomer of the invoice\nonce complete.")
    private let leftArrowCommentView = BottomLeftArrowCommentView(text: "Tapping  \"Payment +\nInvoice\" sends texts to\nconfirm and pay for the\ninvoice to your clients or\ncustomers.")
    
    // MARK: Variables
    private var step: Box<WalkthroughStep>?
    
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
        guard let step = step else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            switch step {
            case .sendInvoice:
                self?.attachmentsCell.alpha = 1
                self?.leftArrowCommentView.alpha = 1
                self?.rightArrowCommentView.alpha = 0
                self?.messageView.alpha = 0
            case .confirmInvoice:
                self?.attachmentsCell.alpha = 0
                self?.leftArrowCommentView.alpha = 0
                self?.rightArrowCommentView.alpha = 1
                self?.messageView.alpha = 1
            default: break
            }
        })
    }
    
    @objc func handleTapSendInvoice() {
        step?.value = .confirmInvoice
        bind(step: step?.value)
    }
    
    private func setView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapSendInvoice))
        attachmentsCell.addGestureRecognizer(tapRecognizer)
        
        contentView.addSubview(messageView)
        contentView.addSubview(rightArrowCommentView)
        attachmentsCell.setCell(model: ChatAttachmentsViewModel.invoice)
        contentView.addSubview(attachmentsCell)
        
        contentView.addSubview(leftArrowCommentView)
        contentView.addSubview(messageInputView)
    }
    
    private func setupConstraints() {
        messageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(safeArea.top).offset(220)
            make.left.right.equalToSuperview()
        }
        rightArrowCommentView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(messageView.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(24)
        }
        leftArrowCommentView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(attachmentsCell.snp.top).inset(-10)
            make.right.equalToSuperview().inset(30)
        }
        attachmentsCell.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(messageInputView.snp.top).inset(-10)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(55)
            make.width.equalTo(ChatAttachmentsViewModel.invoice.cellWidth)
        }
        messageInputView.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalToSuperview()
        }
    }
}
