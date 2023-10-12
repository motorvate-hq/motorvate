//
//  ServiceInformationView.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-08-09.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

private enum Constant {
    static let cornerRadius: CGFloat = 5
    static let jobTypePlaceHolder = "Chrome details ($100.00)"
    static let estimatedDateOfCompletion = "Estimated date of completion"
    static let quote = "$100.00"
    static let formHeaderTitle = "Service Information"
}

final class ServiceInformationView: UIView {

    // MARK: - UI Elements
    fileprivate let jobTypeRow = OnboardingFormRowView(
        labelText: "JOB DETAILS",
        placeHolderText: Constant.jobTypePlaceHolder,
        textViewHeight: 90
    )
    fileprivate let quoteRow = OnboardingFormRowView(
        labelText: "ESTIMATE",
        placeHolderText: Constant.quote,
        inputFormat: .price,
        keyboardType: .decimalPad
    )

    fileprivate let viewModel: OnboardViewModel

    init(viewModel: OnboardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setUI()
        setServiceDetails(serviceDetails: viewModel.serviceDetail)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = Constant.cornerRadius
    }
    
    func setServiceDetails(serviceDetails: [ServiceDetail]?) {
        guard let serviceDetails = serviceDetails else {
            jobTypeRow.setTextValue(value: "")
            quoteRow.setTextValue(value: "")
            return
        }
        let details = serviceDetails.map({ item -> String in
            let description = item.description ?? ""
            let price = String(format: "$%.2f", item.price ?? 0)
            return "\(description) (\(price))"
        }).joined(separator: ", ")
        let totalPrice = serviceDetails.map({ $0.price ?? 0 }).reduce(0, +)
        jobTypeRow.setTextValue(value: details)
        quoteRow.setTextValue(value: String(format: "$%.2f", totalPrice))
    }
}

extension ServiceInformationView {
    func setData() {
        viewModel.setServiceInfo(quoteRow.textValue, jobTypeRow.textValue)
    }
}

fileprivate extension ServiceInformationView {
    func setUI() {
        backgroundColor = .systemBackground
        let formView = FormView(title: Constant.formHeaderTitle, rows: [jobTypeRow, quoteRow])
        formView.translatesAutoresizingMaskIntoConstraints = false
               addSubview(formView)
        formView.fillSuperView()
    }
}

class ServiceInfoMeta: Encodable {
    var jobType: String?
    var estimate: Double?
}

extension ServiceInfoMeta {
    var dictionary: [String: Any] {
        let json: [String: Any] = ["jobType": "\(jobType ?? "")", "quote": estimate ?? 0]
        return json
    }
}
