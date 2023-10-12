//
//  ServiceOptionsView.swift
//  Motorvate
//
//  Created by Bojan on 7.2.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

struct ServiceOptionsView: View {
    var callback: ((Int) -> Void) = { _ in }
    
    var body: some View {
        VStack {
            Text("Select Service Option:")
                .font(AppFont.archivo(.bold, ofSize: 19).font)
                .foregroundColor(R.color.c141414()?.color)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 15) {
                ButtonView(title: "Save Service as Inquiry", image: "service-options-save-service-as-inquiry", background: R.color.c1B34CE(), action: {
                    callback(1)
                })
                ButtonView(title: "Schedule Service", image: "service-options-schedule-service", background: R.color.cFFAE13(), foreground: .black, action: {
                    callback(2)
                })
                ButtonView(title: "Send Estimate / Quote", image: "service-options-send-estimate", background: R.color.c613CBB(), action: {
                    callback(3)
                })
                ButtonView(title: "On-Board Vehicle Now", image: "service-options-onboard-vehicle", background: R.color.c5B9104(), action: {
                    callback(4)
                })
            }
        }
        .padding(10)
        .background(Color.white)
    }
}
