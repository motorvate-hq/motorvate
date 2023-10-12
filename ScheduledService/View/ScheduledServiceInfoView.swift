//
//  ScheduledServiceInfoView.swift
//  Motorvate
//
//  Created by Motorvate on 1.4.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

struct ScheduledServiceInfoView: View {
    @EnvironmentObject var hostingProvider: ViewControllerProvider
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 20) {
                Text("We automate your scheduling for customer vehicle via text 🚗💨  Customers will see your available times based on business hours and job status of vehicles that are currently being serviced.   Two (2) automated text reminders will be sent to customers:  1st  Reminder - 24 hours ahead of schedule service  2nd Reminder - 1 hour ahead of scheduled service   You will receive a notification to confirm whenever scheduled service is requested.")
                    .font(Font(AppFont.archivo(.regular, ofSize: 16)))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ButtonView(title: "Watch Demo (1 Min) 🎥", background: R.color.cFFAE13(), foreground: .black, fullWidth: false, action: {
                    AnalyticsManager.logEvent(.watchInquiryTutorial)
                    
                    hostingProvider.viewController?.present(VideoController(videoType: .automateInquiries), animated: true)
                })
            }
        }
        .padding()
        .background(Color.white)
    }
}
