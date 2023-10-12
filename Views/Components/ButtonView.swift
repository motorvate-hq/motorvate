//
//  ButtonView.swift
//  Motorvate
//
//  Created by Bojan on 7.2.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

struct ButtonView: View {
    var title: String?
    var image: String?
    var background: UIColor? = R.color.c1B34CE()
    var foreground: UIColor? = UIColor.white
    var borderColor: UIColor? = UIColor.clear
    var fullWidth: Bool = true
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                if let image = image {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26, height: 26)
                        .padding(.vertical, 12)
                }
                if let title = title {
                    if fullWidth {
                        Spacer()
                    }
                    
                    Text(title)
                        .font(AppFont.archivo(.semiBold, ofSize: 19).font)
                        .foregroundColor(foreground?.color)
                    
                    if fullWidth {
                        Spacer()
                    }
                }
            }
            .frame(minHeight: 50)
            .if(fullWidth, transform: { view in
                view
                    .frame(maxWidth: .infinity)
            })
            .padding(.horizontal, 20)
            .background(background?.color)
            .cornerRadius(4)
            .if(borderColor != nil, transform: { view in
                view
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(borderColor?.color ?? .clear, lineWidth: 2)
                    )
            })
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            .buttonStyle(PlainButtonStyle())
        })
    }
}
