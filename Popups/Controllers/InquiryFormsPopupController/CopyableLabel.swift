//
//  CopyableLabel.swift
//  Motorvate
//
//  Created by Nikita Benin on 10.08.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

class CopyableLabel: UILabel {
    
    // MARK: - Variables
    var copyText: String?
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(showMenu(sender:))
        ))
    }
    
    override func copy(_ sender: Any?) {
        if let copyText = copyText {
            UIPasteboard.general.string = copyText
        } else {
            UIPasteboard.general.string = text
        }
        
        UIMenuController.shared.hideMenu()
    }
    
    @objc func showMenu(sender: Any?) {
       becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: bounds)
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
       return action == #selector(copy(_:))
    }
}
