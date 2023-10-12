//
//  ScheduleDropOffView.swift
//  Motorvate
//
//  Created by Motorvate on 1.4.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

class InquiryListCoordinatorImpl: InquiryListCoordinatorDelegate {
    var presenter: UIViewController?
    
    func showOnboarding(with inquiry: Inquiry) {
        let service = JobService()
        let viewModel = OnboardViewModel(service, requestMeta: JobRequestMeta())
        viewModel.shouldShowCustomerInquiryView = false
        viewModel.setIquiryIdentifier(inquiry.id)
        viewModel.serviceDetail = inquiry.inquiryDetails
        let viewController = makeRootViewController(OnboardingViewController(viewModel))
        self.presenter?.present(viewController, animated: true, completion: nil)
    }

    private func makeRootViewController(_ rootViewController: UIViewController) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.modalPresentationStyle = .fullScreen
        return navController
    }
}

struct ScheduleDropOffView: View {
    @EnvironmentObject var hostingProvider: ViewControllerProvider
    
    @StateObject var viewModel = ScheduleDropOffViewModel()
    
    @State var selectedDate: Date = Date()

    var canShowPaywallConfirmationView: Bool
    var onLoadCallback: ((UIViewController?) -> Void)?
    
    var subscriptionViewController = SubscriptionViewController()
    var inquiryListCoordinator = InquiryListCoordinatorImpl()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                VStack(spacing: 10) {
                    Button(action: {
                        inquiryListCoordinator.presenter = hostingProvider.viewController
                        
                        let vc = InquiryListViewController()
                        vc.hidesBottomBarWhenPushed = true
                        
                        vc.coordinator = inquiryListCoordinator
                        hostingProvider.viewController?.navigationController?.pushViewController(vc, animated: true)
                    }, label: {
                        HStack {
                            Text("Inquiries")
                                .font(Font(AppFont.archivo(.bold, ofSize: 18)))
                                .foregroundColor(Color(R.color.c141414() ?? .black))
                            
                            Spacer()
                        }
                    })
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(R.color.cDFDFDF() ?? .gray), lineWidth: 2)
                )
                
                VStack(spacing: 10) {
                    Text("(\(viewModel.scheduledServices.count)) Scheduled Drop-Off’s")
                        .font(Font(AppFont.archivo(.bold, ofSize: 18)))
                        .foregroundColor(Color(R.color.c141414() ?? .black))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .clipped()
                        .labelsHidden()
                        .tint(Color(R.color.c1B34CE() ?? .black))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(R.color.cDFDFDF() ?? .gray), lineWidth: 2)
                )
                
                contentView
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 20)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(R.color.cF6F6F6() ?? .white))
        .onLoad {
            onLoadCallback?(hostingProvider.viewController)
            if canShowPaywallConfirmationView {
                showPaywallConfirmationView()
            }
            
            viewModel.refresh(date: selectedDate)
        }
        .onDisappear {
            if !UserSettings().hasSetupAutomatedScheduling {
                hostingProvider.viewController?.presentedViewController?.dismiss(animated: false)
            }
        }
        .onChange(of: selectedDate) { newValue in
            viewModel.refresh(date: newValue)
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        if !UserSettings().hasSetupAutomatedScheduling {
            VStack(spacing: 25) {
                Image("calendar")
                    .resizable()
                    .frame(width: 54, height: 54)
                    .foregroundColor(Color(R.color.c1B34CE() ?? .black))
                
                Text("REDUCE NO SHOWS WITH AUTOMATED SCHEDULING")
                    .font(Font(AppFont.archivo(.bold, ofSize: 17)))
                    .foregroundColor(Color(R.color.c141414() ?? .black))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                
                ButtonView(title: "Watch Demo (1 Min) 🎥", background: R.color.cFFAE13(), foreground: .black, fullWidth: false, action: {
                    AnalyticsManager.logEvent(.watchInquiryTutorial)
                    
                    hostingProvider.viewController?.present(VideoController(videoType: .automateInquiries), animated: true)
                })
                
                ButtonView(title: "7-Day Trial Service Boost 🏁", background: R.color.c1B34CE(), fullWidth: false, action: {
                    viewModel.callback = {
                        showPaywallConfirmationView()
                    }
                    let vc = subscriptionViewController
                    vc.delegate = viewModel
                    
                    guard !SubscriptionViewModel.isDebugMode else {
                        UserSettings().isEntitledToBaseSubscriptionInDebugMode = true
                        vc.render(state: .purchaseSuccess)
                        return
                    }
                    vc.viewModel.purchase()
                })
            }
        } else {
            VStack(spacing: 25) {
                Image("calendar")
                    .resizable()
                    .frame(width: 54, height: 54)
                    .foregroundColor(Color(R.color.c141414() ?? .black))
                
                Text("You can now automate scheduled service 🚗💨\n\nWith your new number, customers can simply text your shop to receive a service form")
                    .font(Font(AppFont.archivo(.bold, ofSize: 17)))
                    .foregroundColor(Color(R.color.c898A8D() ?? .black))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                
                ButtonView(title: "Send Service Form to Customer", fullWidth: false, action: {
                    showInquiryView()
                })
                
                ButtonView(title: "Schedule Service Now", background: R.color.cFFAE13(), foreground: .black, fullWidth: false, action: {
                    showScheduleServiceView()
                })
            }
        }
    }
    
    func showPaywallConfirmationView() {
        let vc = PaywallConfirmationView().embeddedInHostingController()
        vc.modalPresentationStyle = .overCurrentContext
        
        hostingProvider.viewController?.present(vc, animated: false)
    }
    
    func showScheduleServiceView() {
        let vc = ScheduledServiceView(isScheduleToken: true).embeddedInHostingController()
        vc.hidesBottomBarWhenPushed = true
        
        hostingProvider.viewController?.navigationController?.pushViewController(vc, animated: true)
        
        vc.navigationItem.title = "Scheduled Service"
    }
    
    func showInquiryView() {
        let jobService = JobService()
        let inquiryService = InquiryService()
        let viewModel = JobsViewModel(jobService, inquiryService)
        let inquiryViewController = InquiryViewController(viewModel: viewModel, isScheduleToken: true)
        let viewController = makeRootViewController(inquiryViewController)
        hostingProvider.viewController?.present(viewController, animated: true, completion: nil)
    }
    
    private func makeRootViewController(_ rootViewController: UIViewController) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.modalPresentationStyle = .fullScreen
        return navController
    }
}
