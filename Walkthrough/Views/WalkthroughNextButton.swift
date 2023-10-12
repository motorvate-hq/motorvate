//
//  WalkthroughNextButton.swift
//  Motorvate
//
//  Created by Nikita Benin on 04.10.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class WalkthroughNextButton: UIButton {
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    private func setView() {
        layer.addShadow(
            backgroundColor: UIColor(red: 1, green: 0.683, blue: 0.076, alpha: 1),
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.11),
            cornerRadius: 5,
            shadowRadius: 8
        )
        setTitle("Got it!", for: .normal)
        titleLabel?.font = AppFont.archivo(.semiBold, ofSize: 12)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0.5, right: 0)
    }
    
    func startAnimation() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.repeat, .autoreverse, .allowUserInteraction],
            animations: { [weak self] in
                self?.transform = .init(scaleX: 0.95, y: 0.95)
            }
        )
        self.layoutIfNeeded()
    }
}
