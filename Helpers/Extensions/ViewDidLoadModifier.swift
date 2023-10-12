//
//  ViewDidLoadModifier.swift
//  Motorvate
//
//  Created by Motorvate on 2.4.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}
