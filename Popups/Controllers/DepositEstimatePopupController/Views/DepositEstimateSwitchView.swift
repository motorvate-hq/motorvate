//
//  DepositEstimateSwitchView.swift
//  Motorvate
//
//  Created by Nikita Benin on 24.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class DepositEstimateSwitchView: UIView {
    
    // MARK: - UI Elements
    private let selectDepositLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        label.font = AppFont.archivo(.semiBold, ofSize: 15)
        return label
    }()
    private let segmentedControl: UISegmentedControl = UISegmentedControl()
    
    // MARK: - Variables
    var segmentChangeHandler: ((Int) -> Void)?
    var isEnabled: Bool = true {
        didSet {
            segmentedControl.isUserInteractionEnabled = isEnabled
            segmentedControl.alpha = isEnabled ? 1 : 0.4
        }
    }
    
    // MARK: - Lifecycle
    init(title: String, segmentTitles: [String]) {
        super.init(frame: .zero)
        
        selectDepositLabel.text = title
        for (index, segmentTitle) in segmentTitles.enumerated() {
            segmentedControl.insertSegment(withTitle: segmentTitle, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = segmentTitles.count - 1
        
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func segmentDidChange() {
        segmentChangeHandler?(segmentedControl.selectedSegmentIndex)
    }
    
    // MARK: - UI Setup
    private func setView() {
        addSubview(selectDepositLabel)
        segmentedControl.addTarget(self, action: #selector(segmentDidChange), for: .valueChanged)
        addSubview(segmentedControl)
    }
    
    private func setupConstraints() {
        selectDepositLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().inset(12)
        }
        segmentedControl.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(selectDepositLabel.snp.centerY)
            make.width.equalTo(130)
        }
    }
}
