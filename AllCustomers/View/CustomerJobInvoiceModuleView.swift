//
//  CustomerJobInvoiceModuleView.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-12-02.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class CustomerJobInvoiceModuleView: UIView {
    
    enum DetailType {
        case service(service: String, price: Double)
        case discount(amount: Double)
        case total
    }
    
    private enum LabelType {
        case title(text: String)
        case subtitle(text: String)
        case money(amount: Double)
    }
    
    // MARK: - Properties
    
    private let title: String
    private let details: [DetailType]
    private var amounts: [Double] = []
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.archivo(.bold, ofSize: 16)
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    
    init(title: String, details: [DetailType]) {
        self.title = title
        self.details = details
        super.init(frame: .zero)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 4
        
        titleLabel.text = title
        
        addSubview(titleLabel)
        addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            vStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            vStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
                    
        details.forEach({ insertDetail(type: $0) })
    }
    
    private func insertDetail(type: DetailType) {
        switch type {
        case .service(let service, let price):
            amounts.append(price)
            let serviceLabel = label(type: .title(text: service))
            let priceLabel = label(type: .money(amount: price))
            let hStack = UIStackView(arrangedSubviews: [serviceLabel, priceLabel])
            hStack.axis = .horizontal
            vStackView.addArrangedSubview(hStack)
        case .discount(let amount):
            amounts.append(-amount)
            let titleLabel = label(type: .title(text: "Discount"))
            let amountLabel = label(type: .money(amount: -amount))
            let hStack = UIStackView(arrangedSubviews: [titleLabel, amountLabel])
            hStack.axis = .horizontal
            vStackView.addArrangedSubview(hStack)
        case .total:
            let dividerView = UIView()
            dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            dividerView.backgroundColor = AppColor.dividerGrey
            let titleLabel = label(type: .title(text: "TOTAL"))
            let priceLabel = label(type: .money(amount: amounts.sum()))
            let hStack = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
            hStack.axis = .horizontal
            let vStack = UIStackView(arrangedSubviews: [dividerView, hStack])
            vStack.axis = .vertical
            vStack.spacing = 22
            vStackView.addArrangedSubview(vStack)
        }
    }
    
    private func label(type: LabelType) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0

        switch type {
        case .title(let text):
            label.font = AppFont.archivo(.semiBold, ofSize: 15)
            label.textColor = AppColor.textPrimary
            label.text = text
        case .subtitle(let text):
            label.font = AppFont.archivo(.semiBold, ofSize: 12)
            label.textColor = AppColor.textPrimary
            label.text = text
        case .money(let amount):
            label.font = AppFont.archivo(.bold, ofSize: 14)
            label.textColor = AppColor.primaryBlue
            label.text = "\(amount) USD"
            label.textAlignment = .right
        }
        
        return label
    }
}
    
private extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
