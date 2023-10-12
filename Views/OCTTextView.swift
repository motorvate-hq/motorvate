//
//  LinkTextView.swift
//  Motorvate
//
//  Created by Bojan on 7.2.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import UIKit

let OCTLinkAttributeName = "OCTLinkAttributeName"

class LinkTextView: UITextView {
    
    private let _linksAttributes = [NSAttributedString.Key(rawValue: OCTLinkAttributeName), NSAttributedString.Key.link]
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func setup() {
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.onTapAction))
        self.addGestureRecognizer(tapGest)
    }
    
    @objc private func onTapAction(_ tapGest: UITapGestureRecognizer) {
        let location = tapGest.location(in: self)
        let charIndex = self.layoutManager.characterIndex(for: location, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if charIndex < self.textStorage.length {
            var range = NSMakeRange(0, 0)
            
            for linkAttribute in _linksAttributes {
                if let link = self.attributedText.attribute(linkAttribute, at: charIndex, effectiveRange: &range) as? String {
                    _ = self.delegate?.textView?(self, shouldInteractWith: URL(string: link)!, in: range, interaction: .invokeDefaultAction)
                }
            }
        }
    }
}
