//
//  CustomerJobCell.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-11-28.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

protocol CustomerJobCellDelegate: AnyObject {
    func customerJobCell(didSelectButtonFor job: Job, button: PopupActionButton)
}

private struct Constants {
    static let arrowImageViewSize = CGSize(width: 7, height: 12)
}

final class CustomerJobCell: UITableViewCell {
    
    // MARK: - Static properties
    static let imageWidth: CGFloat = UIScreen.main.bounds.width / 2.6
    static let imageHeight: CGFloat = imageWidth * 0.4
    static let cellHeight: CGFloat = imageHeight + 80
    
    // MARK: - Properties
    
    var job: Job!
    weak var delegate: CustomerJobCellDelegate?
    
     let viewInvoiceButton: PopupActionButton  = {
        let button = PopupActionButton(style: .blue)
        button.setTitle("View Invoice", for: .normal)
        return button
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        view.layer.cornerRadius = 6
        view.backgroundColor = .systemBackground
        return view
    }()
    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.bold, ofSize: 12)
        label.textColor = UIColor(named: "componentText")
        return label
    }()

    private let modelLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.bold, ofSize: 14)
        label.textColor = UIColor(named: "componentText")
        label.numberOfLines = 0
        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.semiBold, ofSize: 13)
        label.textColor = UIColor(named: "componentText")
        label.numberOfLines = 0
        return label
    }()

    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.archivo(.regular, ofSize: 13)
        label.textColor = UIColor(named: "componentText")
        label.numberOfLines = 2
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.jobArrow()
        return imageView
    }()
    
    private var verticalStackView = UIStackView()

    // MARK: - Init  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setButtonTarget()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        carImageView.cancelImageLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAsLoading(_ bool: Bool) {
        viewInvoiceButton.setAsLoading(bool)
    }
    
    // MARK: - UI Setup
    private func setupViews() {        
        verticalStackView =
            UIStackView(arrangedSubviews: [
                    UIStackView(arrangedSubviews: [nameLabel, UIView()]),
                    modelLabel,
                    typeLabel,
                    noteLabel
            ])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 6

        contentView.addSubview(borderView)
        borderView.addSubview(carImageView)
        borderView.addSubview(verticalStackView)
        borderView.addSubview(viewInvoiceButton)
        borderView.addSubview(arrowImageView)
    }
    
    private func setupConstraints() {
        borderView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(CustomerJobCell.cellHeight)
            make.bottom.equalToSuperview().inset(8)
        }
        carImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(borderView.snp.top).offset(20)
            make.height.equalTo(CustomerJobCell.imageHeight)
            make.width.equalTo(CustomerJobCell.imageWidth)
            make.leading.equalTo(borderView.snp.leading).offset(20)
        }
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(verticalStackView.snp.width).inset(24)
        }
        verticalStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(borderView.snp.top).offset(12)
            make.leading.equalTo(carImageView.snp.trailing)
            make.trailing.equalTo(arrowImageView.snp.leading).inset(-15)
        }
        viewInvoiceButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(verticalStackView.snp.bottom).offset(12)
            make.leading.equalTo(borderView.snp.leading).offset(15)
            make.height.equalTo(38)
            make.trailing.equalTo(arrowImageView.snp.leading).inset(-15)
            make.bottom.equalTo(borderView.snp.bottom).inset(12)
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

        nameLabel.text = job.contactInfo?.fullName
        modelLabel.text = job.vehicle?.description
        typeLabel.text = "Job Type: \(job.jobType ?? "")"
        noteLabel.text = job.composedNote()
        carImageView.loadImage(at: job.vehicle?.imageURL, placeholder: R.image.carPlaceholder())
        
        setupViews()
        setupConstraints()
    }

    private func setButtonTarget() {
        viewInvoiceButton.addTarget(self, action: #selector(didPressSendMessage), for: .touchUpInside)
    }

    // MARK: Action
    @objc func didPressSendMessage() {
        delegate?.customerJobCell(didSelectButtonFor: job, button: viewInvoiceButton)
    }
}

extension CustomerJobCell: ReusableView {}
