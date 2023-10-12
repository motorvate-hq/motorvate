//
//  UpcomingCell.swift
//  Motorvate
//
//  Created by Emmanuel on 8/3/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

protocol UpcomingCellDelegate: AnyObject {
    func upcomingCell(_ cell: UpcomingCell, didTapButton type: UpcomingCellButtonType)
}

enum UpcomingCellButtonType {
    case sendMessage(customerId: String, inquiryId: String)
    case onboard(inquiry: Inquiry)
}

final class UpcomingCell: UITableViewCell {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var vehicleInfoLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var viewHolder: UIView!
    @IBOutlet weak var onboardCustomerButton: UIButton!

    private var inquiry: Inquiry?
    private var customerId: String?

    weak var delegate: UpcomingCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.isUserInteractionEnabled = false
        styleComponents()
    }

    @IBAction func didPressSendMessage(_ sender: Any) {
        guard let customerId = customerId, let inquiryId = inquiry?.id else { return }
        delegate?.upcomingCell(self, didTapButton: .sendMessage(customerId: customerId, inquiryId: inquiryId))
    }

    @IBAction func didPressCustomerHere(_ sender: Any) {
        guard let inquiry = inquiry else { return }
        delegate?.upcomingCell(self, didTapButton: .onboard(inquiry: inquiry))
    }
}

extension UpcomingCell {
    public func configure(with viewModel: InquiryListViewModel, indexPath: IndexPath) {
        let inqury = viewModel.item(at: indexPath)
                
        inquiry = inqury
        customerId = inqury.customer?.customerID
        
        fullNameLabel.text = inqury.customer?.fullName
        vehicleInfoLabel.text = inqury.model
        jobTypeLabel.text = "JobType: \(inqury.service)"
        noteLabel.text = inqury.note
        onboardCustomerButton.setTitle("Start Onboard", for: .normal)
    }
    
    func configureMockCell() {
        fullNameLabel.text = "Mike Jones"
        vehicleInfoLabel.text = "Porsche Turbo 997"
        jobTypeLabel.text = "JobType: Platinum Detail Pakage"
        noteLabel.text = ""
        onboardCustomerButton.setTitle("Start Onboard", for: .normal)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        fullNameLabel.text = ""
        vehicleInfoLabel.text = ""
        jobTypeLabel.text = ""
        noteLabel.text = ""
        onboardCustomerButton.setTitle("", for: .normal)
    }
}

private extension UpcomingCell {
    private func styleComponents() {
        viewHolder.layer.borderColor = UIColor(hex: 0xDFDFDF).cgColor
        viewHolder.layer.borderWidth = 2.0
        viewHolder.layer.cornerRadius = 4.0
        
        clipsToBounds = true
        selectionStyle = .none
    }
}

// MARK: - ReusableView
extension UpcomingCell: ReusableView {}
extension UpcomingCell: NibLoadableView {}
