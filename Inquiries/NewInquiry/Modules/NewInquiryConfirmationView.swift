//
//  NewInquiryConfirmationView.swift
//  Motorvate
//
//  Created by Bojan on 2.3.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

struct NewInquiryConfirmationView: View {
    var callback: ((Int) -> Void) = { _ in }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image("green-checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                
                Text("New inquiry saved successfully ")
                    .font(AppFont.archivo(.bold, ofSize: 19).font)
                    .foregroundColor(R.color.c141414()?.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 10) {
                Text("Would you like to add an extra option?")
                    .font(AppFont.archivo(.regular, ofSize: 17).font)
                    .foregroundColor(R.color.c141414()?.color)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    
                }, label: {
                    HStack {
                        Text("Learn more")
                            .font(AppFont.archivo(.regular, ofSize: 17).font)
                            .foregroundColor(R.color.c1B34CE()?.color)
                        Image("arrow-right-pointer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 13, height: 18)
                    }
                })
            }
            
            VStack(spacing: 15) {
                ButtonView(title: "On-Board Vehicle Now", background: R.color.c5B9104(), action: {
                    callback(1)
                })
                ButtonView(title: "Send as Estimate / Quote", background: R.color.c613CBB(), action: {
                    callback(2)
                })
                ButtonView(title: "Add to Scheduled Service", background: R.color.cFFAE13(), foreground: .black, action: {
                    callback(3)
                })
                ButtonView(title: "Skip", background: UIColor.white, foreground: R.color.c1B34CE(), borderColor: R.color.c1B34CE(), action: {
                    callback(4)
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        .background(Color.white)
    }
}
