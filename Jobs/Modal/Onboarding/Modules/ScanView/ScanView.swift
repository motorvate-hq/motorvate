//
//  ScanView.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

protocol ScanViewDelegate: AnyObject {
    func handleScan(type: ScanButtonType)
}

enum ScanViewState {
    case normal
    case loading
    case scannedPlate(plate: String)
    case scannedVin(vin: String)
}

class ScanView: UIView {
    
    // MARK: - UI Elements
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .black
        return activityIndicatorView
    }()
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 6
        stackView.axis = .vertical
        return stackView
    }()
    private let scanResultView = ScanResultView()
    
    // MARK: - Variables
    weak var delegate: ScanViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setState(.normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setState(_ state: ScanViewState) {
        let views = [activityIndicatorView, vStackView, scanResultView]
        _ = views.map({ $0.alpha = 0 })
        switch state {
        case .normal:
            backgroundColor = .clear
            vStackView.alpha = 1
        case .loading:
            backgroundColor = .white
            activityIndicatorView.alpha = 1
        case .scannedPlate(let plate):
            backgroundColor = .white
            scanResultView.setView(type: .licensePlate, value: plate)
            scanResultView.alpha = 1
        case .scannedVin(let vin):
            backgroundColor = .white
            scanResultView.setView(type: .vin, value: vin)
            scanResultView.alpha = 1
        }
    }
    
    @objc func handleButtonTap(_ sender: ScanButton) {
        delegate?.handleScan(type: sender.type)
    }
    
    // MARK: - Setup UI
    private func setupView() {
        layer.cornerRadius = 6
        addSubview(activityIndicatorView)
        for type in ScanButtonType.allCases {
            let button = ScanButton(type: type)
            button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
            vStackView.addArrangedSubview(button)
            let orLabel: UILabel = {
                let label = UILabel()
                label.text = "OR"
                label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
                label.font = AppFont.archivo(.regular, ofSize: 15)
                label.textAlignment = .center
                return label
            }()
            vStackView.addArrangedSubview(orLabel)
        }
        addSubview(vStackView)
        addSubview(scanResultView)
    }
    
    private func setupConstraints() {
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scanResultView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
