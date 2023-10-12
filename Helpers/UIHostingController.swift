//
//  UIHostingController.swift
//  Motorvate
//
//  Created by Bojan on 7.2.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

class BaseSwiftUIView<T>: UIView where T : View {
    var hostingViewController: UIViewController?
    
    init(rootView: T) {
        super.init(frame: .zero)
        
        self.hostingViewController = UIHostingController(rootView: rootView)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setupUI() {
        guard let view = self.hostingViewController?.view else { return }
        
        for _ in 0..<self.subviews.count {
            if self.subviews[0].tag > 0 {
                self.subviews[0].removeFromSuperview()
            }
        }
        
        self.addSubview(view)
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}
