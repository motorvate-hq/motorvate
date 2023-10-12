//
//  ManualVinInputView.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private enum Constant {
    static let formHeaderTitle = "Manual Insert VIN"
    static let vinRowPlaceholder = "1234ABCD567890EFG"
}

class ManualVinInputView: UIView {
    
    // MARK: - UI Elements
    private let vinRow = OnboardingFormRowView(
        labelText: "VIN",
        placeHolderText: Constant.vinRowPlaceholder
    )
    
    init() {
        super.init(frame: .zero)
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
    }
    
    private func setUI() {
        backgroundColor = .systemBackground
        
        let formView = FormView(title: Constant.formHeaderTitle, rows: [vinRow])
        formView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(formView)
        formView.fillSuperView()
    }
    
    func setManualVin(_ vin: String) {
        vinRow.setTextValue(value: vin)
    }
    
    func getManualVin() -> String? {
        return vinRow.textValue
    }
}
