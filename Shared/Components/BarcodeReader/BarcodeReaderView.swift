//
//  BarcodeReaderView.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-08-12.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

protocol BarcodeReaderViewDelegate: AnyObject {
    func barcodeReaderView(_ barcodeView: BarcodeReaderView, didPress button: UIButton)
}

final class BarcodeReaderView: UIView {

    private let button: UIButton = {
        let button = UIButton(type: .system)
        let image = R.image.barcode()?.withRenderingMode(.alwaysTemplate) 
        button.setImage(image, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -6)
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = AppFont.archivo(.bold, ofSize: 15.7)
        return button
    }()

    private let vehicleVinLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = AppFont.archivo(ofSize: 20)
        return label
    }()

    weak var delegate: BarcodeReaderViewDelegate?

    private var vehicleVin: String? {
        didSet {
            setState()
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setState()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setVehicleIdentificationNumber(_ vin: String?) {
        vehicleVin = vin
    }

    // MARK: - UI

    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 6

        let vStackView = UIStackView(arrangedSubviews: [button, vehicleVinLabel])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.alignment = .center
        vStackView.distribution = .fillProportionally
        vStackView.spacing = 12
        addSubview(vStackView)

        vStackView.fillSuperView(insets: UIEdgeInsets(top: 12, left: 32, bottom: 12, right: 32))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onButtonPressed))
        addGestureRecognizer(tapGestureRecognizer)
    }

    private func setState() {
        if vehicleVin != nil {
            backgroundColor = .white
            button.setTitle("", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.tintColor = .black
            updateVehicleLabels()
        } else {
            backgroundColor = AppColor.darkYellowGreen
            button.setTitle("Scan VIN", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.tintColor = .white
            vehicleVinLabel.isHidden = true
            button.isEnabled = true
        }
    }

    @objc func onButtonPressed() {
        delegate?.barcodeReaderView(self, didPress: button)
    }
}

fileprivate extension BarcodeReaderView {
    func updateVehicleLabels() {
        vehicleVinLabel.text = vehicleVin
        vehicleVinLabel.isHidden = false
        button.isEnabled = false
    }
}
