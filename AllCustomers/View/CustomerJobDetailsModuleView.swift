//
//  CustomerDetailsModuleView.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-12-01.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class CustomerJobDetailsModuleView: UIView {
    
    enum DetailType {
        case title(_ title: String)
        case subtitle(_ subtitle: String)
        case subtitleWithText(subtitle: String, text: String, spacing: CGFloat = 10)
        case divider(height: CGFloat)
        case custom(view: UIView)
    }
    
    private enum LabelType {
        case title(text: String)
        case subtitle(text: String)
        case text(text: String)
    }
    
    // MARK: - Properties
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.layer.cornerRadius = 4
        return stackView
    }()
    
    private let details: [DetailType]
    
    // MARK: - Init
    init(details: [DetailType]) {
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

        addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            vStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
                    
        details.forEach({ insertDetail(type: $0) })
    }
    
    private func addSideInsets(innerView: UIView, inset: CGFloat) {
        innerView.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(inset)
            make.right.equalToSuperview().inset(inset)
        }
    }
    
    private func insertDetail(type: DetailType) {
        switch type {
        case .title(let title):
            let titleLabel = label(type: .title(text: title))
            let containerView = UIView()
            containerView.addSubview(titleLabel)
            vStackView.addArrangedSubview(containerView)
            addSideInsets(innerView: titleLabel, inset: 15)
            
        case .subtitle(let subtitle):
            let titleLabel = label(type: .title(text: subtitle))
            let containerView = UIView()
            containerView.addSubview(titleLabel)
            vStackView.addArrangedSubview(containerView)
            addSideInsets(innerView: titleLabel, inset: 16)
        case .subtitleWithText(let subtitle, let text, let spacing):
            let subtitleLabel = label(type: .subtitle(text: subtitle))
            let textLabel = label(type: .text(text: text))
            let stack = UIStackView(arrangedSubviews: [subtitleLabel, textLabel])
            let containerView = UIView()
            containerView.addSubview(stack)
            stack.spacing = spacing
            stack.axis = .vertical
            stack.alignment = .leading
            vStackView.addArrangedSubview(containerView)
            addSideInsets(innerView: stack, inset: 16)
        case .divider(let height):
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: height)
            ])
            vStackView.addArrangedSubview(view)
        case .custom(let view):
            vStackView.addArrangedSubview(view)
        }
    }
    
    private func label(type: LabelType) -> UILabel {
        let label = UILabel()
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0

        switch type {
        case .title(let text):
            label.font = AppFont.archivo(.bold, ofSize: 16)
            label.text = text
        case .subtitle(let text):
            label.font = AppFont.archivo(.semiBold, ofSize: 15)
            label.text = text
        case .text(let text):
            label.font = AppFont.archivo(.regular, ofSize: 12)
            label.text = text
        }
        
        return label
    }
}
    
