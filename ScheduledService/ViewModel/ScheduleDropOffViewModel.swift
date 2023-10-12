//
//  ScheduleDropOffViewModel.swift
//  Motorvate
//
//  Created by Motorvate on 20.4.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import Foundation

class ScheduleDropOffViewModel: ObservableObject {
    @Published var scheduledServices: [ScheduledService] = []
    
    var jobService = JobService()
    
    var callback: (() -> Void) = {}
    
    init() {
        if UserSession.shared.shop?.scheduledData?.count ?? 0 > 0 {
            UserSettings().hasSetupAutomatedScheduling = true
        }
    }
    
    func refresh(date: Date) {
        guard let shopID = UserSession.shared.shopID else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let parameters: Parameters = [
            "shopID": shopID,
            "scheduledDate": dateFormatter.string(from: date)
        ]
        jobService.getScheduledService(with: parameters) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let scheduledServices):
                strongSelf.scheduledServices = scheduledServices
            case .failure(let error):
                CrashlyticsManager.recordError(.apiError(error: error as NSError), error: error as NSError)
                print("failed to fetch scheduled services with status error: \(error)")
            }
        }
    }
}

// MARK: - SubscriptionViewControllerDelegate
extension ScheduleDropOffViewModel: SubscriptionViewControllerDelegate {
    func didCompletePurchase() {
        callback()
    }
}
