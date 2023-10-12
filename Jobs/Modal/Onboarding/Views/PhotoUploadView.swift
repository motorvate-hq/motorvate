//
//  PhotoUploadView.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-08-11.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

protocol VehicleConditionViewItemDelegate: AnyObject {
    func vehicleConditionViewdidSelect(_ region: VehicleConditionItemView.Region)
}

final class VehicleConditionItemView: UIView {
    enum Region: CaseIterable {
        case front
        case left
        case back
        case right
        case top
        case none
    }

    private let imageContainerView: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = .white
         return view
     }()

     private let imageView: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.backgroundColor = .purple
         imageView.contentMode = .scaleAspectFit
         imageView.tintColor = AppColor.highlightGreen
         return imageView
     }()

    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .purple
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.tintColor = AppColor.highlightGreen
        return imageView
    }()

     private let imageLabel: UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "Sample Text"
         label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
         label.textColor = .white
         return label
     }()

    weak var delegate: VehicleConditionViewItemDelegate?

    private(set) var region: Region

    var image: UIImage? {
        didSet {
            if image != nil {
                selectedImageView.image = image
                selectedImageView.isHidden = false
                imageContainerView.isHidden = true
            } else if image == nil {
                selectedImageView.isHidden = true
                imageContainerView.isHidden = false
            }
        }
    }

    init(with region: Region) {
        self.region = region
        super.init(frame: .zero)
        
        imageLabel.text = region.stringValue
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private func setUI() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressed)))
        backgroundColor = AppColor.darkYellowGreen
        layer.cornerRadius = 6
        clipsToBounds = true

        addSubview(selectedImageView)
        addSubview(imageContainerView)
        addSubview(imageLabel)
        imageContainerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            imageContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            imageContainerView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),

            selectedImageView.topAnchor.constraint(equalTo: topAnchor),
            selectedImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectedImageView.widthAnchor.constraint(equalTo: widthAnchor),
            selectedImageView.heightAnchor.constraint(equalTo: widthAnchor),

            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.7),

            imageLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 6),
            imageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)])
    }

    override func draw(_ rect: CGRect) {
        imageContainerView.layer.cornerRadius = imageContainerView.frame.width / 2
    }

    // MARK: - Objc

    @objc private func onPressed() {
        delegate?.vehicleConditionViewdidSelect(region)
    }
}

extension VehicleConditionItemView.Region {
    var stringValue: String {
        switch self {
        case .front:
            return "Front"
        case .left:
            return "Left"
        case .back:
            return "Back"
        case .right:
            return "Right"
        case .top:
            return "Top"
        case .none:
            return ""
        }
    }
}
