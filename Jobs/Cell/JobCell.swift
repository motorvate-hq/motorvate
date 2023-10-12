//
//  JobCell.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-26.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

public enum JobCellButtonType {
    case message
    case status
}

protocol JobCellDelegate: AnyObject {
    func jobCell(_ jobCell: JobCell, didSelectButton type: JobCellButtonType, job: Job?)
}

private struct Constants {
    static let arrowImageViewSize = CGSize(width: 7, height: 12)
}

final class JobCell: UICollectionViewCell {
    
    static let imageWidth: CGFloat = UIScreen.main.bounds.width / 2.8
    static let imageHeight: CGFloat = imageWidth * 0.4
    static let cellHeight: CGFloat = imageHeight + 90
    
    private let sendMessageButton = AppButton(title: "Send Message")
    private let statusButton = AppButton()
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.jobArrow()
        return imageView
    }()

    var job: Job?
    weak var delegate: JobCellDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = AppColor.backgroundGrey.cgColor
        contentView.layer.cornerRadius = 6
        contentView.backgroundColor = .systemBackground
        
        setButtonTarget()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let attr = super.preferredLayoutAttributesFitting(layoutAttributes)
        var frame = attr.frame
        frame.size.width = layoutAttributes.size.width
        attr.frame = frame
        return attr
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        carImageView.cancelImageLoad()
    }

    private func setConstraints() {
        let horizontalStackView = UIStackView(arrangedSubviews: [sendMessageButton, statusButton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 15
        
        let verticalStackView =
            UIStackView(arrangedSubviews: [
                            UIStackView(arrangedSubviews: [nameLabel, UIView()]),
                            modelLabel,
                            typeLabel,
                            noteLabel
            ])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillProportionally
        verticalStackView.spacing = 5

        contentView.addSubview(carImageView)
        contentView.addSubview(horizontalStackView)
        contentView.addSubview(verticalStackView)
        
        contentView.addSubview(arrowImageView)
        
        carImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(JobCell.imageHeight)
            make.width.equalTo(JobCell.imageWidth)
            make.centerY.equalTo(verticalStackView.snp.centerY)
            make.leading.equalToSuperview().inset(25)
        }
        verticalStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(carImageView.snp.trailing).offset(27)
            make.trailing.equalTo(arrowImageView.snp.leading).inset(-15)
        }
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(verticalStackView.snp.width).inset(24)
        }
        horizontalStackView.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(verticalStackView.snp.bottom).offset(13)
            make.trailing.equalTo(arrowImageView.snp.leading).inset(-15)
            make.bottom.equalToSuperview().inset(12)
        }
        arrowImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.arrowImageViewSize)
            make.right.equalToSuperview().inset(15)
        }
    }

    // MARK: - Operations
    func configure(for job: Job) {
        self.job = job

        sendMessageButton.configure(as: .primary)

        switch job.status {
        case .completed:
            statusButton.configure(as: .secondary(titleColor: .white, backgroundColor: AppColor.darkYellowGreen))
            statusButton.setTitle("Done", for: .normal)
            statusButton.isUserInteractionEnabled = false
        case .inProgress:
            statusButton.configure(as: .secondary(titleColor: .black, backgroundColor: AppColor.highlightYellow))
            statusButton.setTitle("In Progress", for: .normal)
            statusButton.isUserInteractionEnabled = true
        case .inqueue:
            statusButton.configure(as: .secondary(titleColor: .white, backgroundColor: AppColor.bluePurple))
            statusButton.setTitle("In Queue", for: .normal)
            statusButton.isUserInteractionEnabled = true
        case .none: break
        }

        let fullName = job.contactInfo?.fullName ?? ""
        nameLabel.text = "\(fullName)'s"
        modelLabel.text = job.vehicle?.description

        let jobTypeAttributedString = NSMutableAttributedString(string: "Job Type: ",
                                                                attributes: [NSAttributedString.Key.font: AppFont.archivo(.semiBold, ofSize: 12.7)])
        jobTypeAttributedString.append(NSAttributedString(string: job.jobType ?? "", attributes: [NSAttributedString.Key.font: AppFont.archivo(.regular, ofSize: 12.7)]))

        typeLabel.attributedText = jobTypeAttributedString
        noteLabel.text = job.composedNote()
        carImageView.loadImage(at: job.vehicle?.imageURL, placeholder: R.image.carPlaceholder())
        
        setConstraints()
    }

    private func setButtonTarget() {
        sendMessageButton.addTarget(self, action: #selector(didPressSendMessage), for: .touchUpInside)
        statusButton.addTarget(self, action: #selector(didPressStatusButton), for: .touchUpInside)
    }

    // MARK: Action
    @objc func didPressSendMessage() {
        delegate?.jobCell(self, didSelectButton: .message, job: job)
    }

    @objc func didPressStatusButton() {
        delegate?.jobCell(self, didSelectButton: .status, job: job)
    }
    
    func disableButtons(sendMessage: Bool, status: Bool) {
        sendMessageButton.alpha = sendMessage ? 0.3 : 1
        statusButton.alpha = status ? 0.3 : 1
    }

    // MARK: - Components
    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.bold, ofSize: 12.7)
        label.textColor = UIColor(named: "componentText")
        return label
    }()

    private let modelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.bold, ofSize: 14.3)
        label.textColor = UIColor(named: "componentText")
        label.numberOfLines = 2
        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(ofSize: 12.7)
        label.textColor = UIColor(named: "componentText")
        return label
    }()

    private let noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(ofSize: 12.7)
        label.textColor = UIColor(named: "componentText")
        label.numberOfLines = 2
        return label
    }()
}

extension JobCell: ReusableView {}
