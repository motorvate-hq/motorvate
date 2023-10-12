//
//  AppButton.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-01-31.
//  Copyright © 2020 motorvate. All rights reserved.
//

import UIKit

final class AppButton: UIButton {

    enum Style {
        case primary
        case passive
        case secondary(titleColor: UIColor, backgroundColor: UIColor)
    }

    init(title: String? = nil) {
        super.init(frame: .zero)
        commonInit()

        setTitle(title, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        clipsToBounds = true
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        contentEdgeInsets = .init(top: 12, left: 24, bottom: 12, right: 24)
        layer.cornerRadius = 5
        titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 12.7)
    }

    func setFont(font: UIFont) {
        titleLabel?.font = font
    }
    
    func configure(as style: Style) {
        switch style {
        case .primary:
            setTitleColor(.white, for: .normal)
            backgroundColor = AppColor.primaryBlue
            layer.shadowRadius = 2
            layer.shadowOpacity = 0.3
            layer.shadowOffset = .init(width: 2, height: 2)
            layer.shadowColor = UIColor.black.cgColor
        case .passive:
            backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            setTitleColor(.black, for: .normal)
        case .secondary(let titleColor, let backgroundColor):
            self.backgroundColor = backgroundColor
            setTitleColor(titleColor, for: .normal)
        }
    }

    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        if state == .normal {
            self.setTitleColor(color?.withAlphaComponent(0.3), for: .highlighted)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.transition(with: self,
                          duration: 0.2,
                          options: [.allowUserInteraction, .transitionCrossDissolve],
                          animations: { self.isHighlighted = true },
                          completion: nil)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.transition(with: self,
                          duration: 0.2,
                          options: [.allowUserInteraction, .transitionCrossDissolve],
                          animations: { self.isHighlighted = false },
                          completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.transition(with: self,
                          duration: 0.2,
                          options: [.allowUserInteraction, .transitionCrossDissolve],
                          animations: { self.isHighlighted = false },
                          completion: nil)
    }
}
