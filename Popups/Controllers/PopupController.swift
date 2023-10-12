//
//  PopupController.swift
//  Motorvate
//
//  Created by Nikita Benin on 24.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let animationDuration: TimeInterval = 0.3
}

class PopupController: UIViewController {
    
    // MARK: - UI Elements
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        return view
    }()
    
    // MARK: - Variables
    let needAnimateAppear: Bool
    
    // MARK: - Lifecycle
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, needAnimateAppear: Bool = true) {
        self.needAnimateAppear = needAnimateAppear
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needAnimateAppear {
            view.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needAnimateAppear {
            animateAppear()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
    }
    
    @objc func animateAndDismiss() {
        animateDisappear(completion: { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        })
    }
    
    private func animateAppear() {
        view.alpha = 0
        UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
            self?.view.alpha = 1
        })
    }
    
     func animateDisappear(completion: ((Bool) -> Void)?) {
        view.alpha = 1
        UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
            self?.view.alpha = 0
        }, completion: completion)
    }
    
    // MARK: - UI Setup
    private func setView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateAndDismiss))
        coverView.addGestureRecognizer(tapRecognizer)
        view.addSubview(coverView)
    }
    
    private func setupConstraints() {
        coverView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
