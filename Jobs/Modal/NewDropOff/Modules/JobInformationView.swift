//
//  JobInformationView.swift
//  Motorvate
//
//  Created by Charlie on 2019-08-21.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class JobInformationView: UIView {

    fileprivate enum Constant {
        static let cornerRadius: CGFloat = 4.4
        static let footerText = "Not all fields need to be filled. Fill in what you have, even just a vague service request."
        static let modelPlaceHolder = "BMW X5 from 2009"
        static let servicePlaceHolder = "Vinly wrap"
        static let notesPlaceHolder = "Needs it done in a day"
    }

    fileprivate let carModelRow = OnboardingFormRowView(labelText: "CAR MODEL", placeHolderText: Constant.modelPlaceHolder)
    fileprivate let inquiredServiceRow = OnboardingFormRowView(labelText: "SERVICE", placeHolderText: Constant.servicePlaceHolder)
    fileprivate let additionalNotesRow = OnboardingFormRowView(labelText: "NOTES", placeHolderText: Constant.notesPlaceHolder)

    var viewModel: JobsViewModel

    init(viewModel: JobsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        backgroundColor = .systemBackground
        setupUI()
        configure(with: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = Constant.cornerRadius
    }

    func configure(with viewModel: JobsViewModel) {
        let info = viewModel.jobInfoMeta

        carModelRow.setTextValue(value: info.carModel)
        inquiredServiceRow.setTextValue(value: info.service)
        additionalNotesRow.setTextValue(value: info.note)
    }

    func setData() {
        let carModel = carModelRow.textValue
        let notes = additionalNotesRow.textValue
        let service = inquiredServiceRow.textValue
        
        viewModel.setJobInfo(carModel, notes, service)
    }
}

fileprivate extension JobInformationView {
    func setupUI(with footerText: String? = nil) {
        let formView = FormView(title: "Job Information", rows: [carModelRow, inquiredServiceRow, additionalNotesRow], footerText: footerText)
        formView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(formView)
        formView.fillSuperView()
    }
}

class JobInfoMeta: Encodable {
    var carModel: String?
    var service: String?
    var note: String?
}

extension JobInfoMeta {
    var dictionary: [String: Any] {
        let json: [String: Any] = [
            "carModel": "\(carModel ?? "")",
            "service": "\(service ?? "")",
            "note": "\(note ?? "")"
        ]
        return json
    }
}
