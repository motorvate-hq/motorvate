//
//  PaywallConfirmationView.swift
//  Motorvate
//
//  Created by Motorvate on 9.4.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

struct PaywallConfirmationView: View {
    @EnvironmentObject var hostingProvider: ViewControllerProvider
    
    var body: some View {
        ZStack {
            VStack {
                
            }
            .frame(width: 600, height: 600)
            .background(Color.white)
            .clipShape(Circle())
            
            VStack(spacing: 20) {
                Image("paywall-confirmation-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280, height: 280)
                    .padding(.vertical, -20)
                
                VStack(spacing: 5) {
                    Text("Welcome \(UserSession.shared.shopName) 🚗💨")
                    Text("Your Service Boost Trial Has Started")
                }
                .font(Font(AppFont.archivo(.bold, ofSize: 18)))
                .foregroundColor(Color.black)
                
                VStack(spacing: 5) {
                    Text("We are excited to have you as a partner!")
                    Text("Let’s begin improving your customer experience")
                }
                .font(Font(AppFont.archivo(.regular, ofSize: 16)))
                .foregroundColor(Color.black)
                
                ButtonView(title: "Watch Demo (1 Min) 🎥", background: R.color.cFFAE13(), foreground: .black, fullWidth: false, action: {
                    AnalyticsManager.logEvent(.watchInquiryTutorial)
                    
                    hostingProvider.viewController?.present(VideoController(videoType: .automateInquiries), animated: true)
                })
                
                ButtonView(title: "Setup Automated Scheduling 🏁", background: R.color.c1B34CE(), fullWidth: false, action: {
                    let vc = ScheduledServiceView(isScheduleToken: true).embeddedInHostingController()
                    vc.hidesBottomBarWhenPushed = true
                    
                    let parentVC = hostingProvider.viewController?.presentingViewController

                    hostingProvider.viewController?.dismiss(animated: false)
                    
                    DispatchQueue.main.async {
                        (parentVC as? UINavigationController)?.pushViewController(vc, animated: true)
                    }
                })
            }
            .padding(15)
            .padding(.top, -50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
    }
}
