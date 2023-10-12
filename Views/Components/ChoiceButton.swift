//
//  ChoiceButton.swift
//  Motorvate
//
//  Created by Motorvate on 1.4.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

struct ChoiceButtontyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .animation(nil)
    }
    
    static func background(isSelected: Bool) -> UIColor {
        isSelected ? (R.color.cFFAE13() ?? .clear) : .clear
    }
}

struct ChoiceButton: View {
    var title: String?
    var image: String?
    var background: UIColor? = UIColor.clear
    var foreground: UIColor? = R.color.c141414()
    var borderColor: UIColor? = R.color.c979797()
    
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                if let image = image {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26, height: 26)
                        .padding(.vertical, 12)
                }
                if let title = title {
                    Text(title)
                        .font(AppFont.archivo(.semiBold, ofSize: 16).font)
                        .foregroundColor(foreground?.color)
                }
            }
            .frame(minHeight: 44)
            .padding(.horizontal, 10)
            .background(background?.color)
            .cornerRadius(4)
            .if(borderColor != nil, transform: { view in
                view
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(borderColor?.color ?? .clear, lineWidth: 2)
                    )
            })
        })
        .buttonStyle(ChoiceButtontyle())
    }
}
