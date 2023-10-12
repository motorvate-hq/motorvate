//
//  ScheduledServiceView.swift
//  Motorvate
//
//  Created by Motorvate on 6.3.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI
import SafariServices

struct ScheduledServiceView: View {
    @EnvironmentObject var hostingProvider: ViewControllerProvider
    
    @StateObject var businessHoursViewModel = BusinessHoursViewModel()
    @StateObject var vehiclesInfoViewModel = VehiclesInfoViewModel()
    
    fileprivate let viewModel: JobsViewModel
    fileprivate let settingsViewModel: SettingsViewModel
    
    var isScheduleToken: Bool
    
    init(isScheduleToken: Bool) {
        self.isScheduleToken = isScheduleToken
        
        let jobService = JobService()
        let inquiryService = InquiryService()
        viewModel = JobsViewModel(jobService, inquiryService)
        
        settingsViewModel = SettingsViewModel(AccountService())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                BusinessHoursView(viewModel: businessHoursViewModel)
                
                VehiclesInfoView(viewModel: vehiclesInfoViewModel)
                
                ScheduledServiceInfoView()
                
                VStack(spacing: 15) {
                    ButtonView(title: "Preview Service Form", background: R.color.c5B9104(), action: {
                        handlePreviewServiceForm()
                    })
                    
                    ButtonView(title: "Save & Begin Automated Scheduling 🏁", background: R.color.c1B34CE(), action: {
                        hostingProvider.viewController?.setAsLoading(true)
                        
                        settingsViewModel.createScheduledService(scheduledData: businessHoursViewModel.scheduledData, shopSize: vehiclesInfoViewModel.shopSize) { result in
                            hostingProvider.viewController?.setAsLoading(false)
                            
                            switch result {
                            case .success(let success):
                                hostingProvider.viewController?.navigationController?.popViewController(animated: true)
                            default: break
                            }
                        }
                    })
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(R.color.cF6F6F6() ?? .white))
        .onLoad {
            businessHoursViewModel.configure(with: settingsViewModel.scheduledData)
        }
    }
    
    private func handlePreviewServiceForm() {
        guard
            let shop = UserSession.shared.shop,
            let shopTelephone = shop.shopTelephone
        else { return }
        
        hostingProvider.viewController?.setAsLoading(true)
        viewModel.getFormInfo(with: shopTelephone, isScheduleToken: isScheduleToken, completion: { result in
            hostingProvider.viewController?.setAsLoading(false)
            
            switch result {
            case .success(let formInfo):
                guard
                    let key = formInfo.key,
                    let url = URL(string: "\(Environment.webURL)/?key=\(key)")
                else { return }
                
                hostingProvider.viewController?.present(SFSafariViewController(url: url), animated: true)
            case .failure(let error):
                guard let vc = hostingProvider.viewController else { return }
                
                BaseViewController.presentAlert(message: error.localizedDescription, okHandler: {
                    
                }, from: vc)
            }
        })
    }
}
