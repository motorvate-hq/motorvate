//
//  CommunicationViewCell.swift
//  Motorvate
//
//  Created by Emmanuel on 11/10/19.
//  Copyright © 2019 motorvate. All rights reserved.
//
import UIKit

class CommunicationViewCell: UITableViewCell {

    @IBOutlet private var avatarView: CommunicationAvatarView!
    @IBOutlet private var fullNameLabel: UILabel!
    @IBOutlet private var recentMessageLabel: UILabel!
    @IBOutlet private var divider: UIView!
    @IBOutlet private var vehicleInfo: UILabel!
    @IBOutlet private var unseenIndicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        unseenIndicatorView.layer.cornerRadius = 9
    }

    fileprivate func hideDivider() {
        divider.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.cancelImageLoad()
    }

    func configure(with history: ChatHistory, isLastAtIndex: Bool) {
        let fullName = history.customer.fullName ?? ""
        let carModel = history.jobs?.last?.vehicle?.description ?? history.inquiries?.first?.model ?? ""
        fullNameLabel.attributedText = NSMutableAttributedString(string: fullName, attributes: [NSAttributedString.Key.kern: -0.24])
        vehicleInfo.attributedText = NSMutableAttributedString(string: carModel, attributes: [NSAttributedString.Key.kern: -0.3])
        recentMessageLabel.attributedText = NSMutableAttributedString(string: history.chat.last?.text ?? "", attributes: [NSAttributedString.Key.kern: -0.36])
        avatarView.configure(imageUrl: history.jobs?.last?.vehicle?.imageURL)
        
        if let unreadQuantity = history.unreadQuantity, unreadQuantity != 0 {
            unseenIndicatorView.isHidden = false
        } else {
            unseenIndicatorView.isHidden = true
        }
        
        if isLastAtIndex {
            hideDivider()
        }
    }
}

extension CommunicationViewCell: ReusableView, NibLoadableView {}
