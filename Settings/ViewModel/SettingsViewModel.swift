//
//  SettingsViewModel.swift
//  Motorvate
//
//  Created by Charlie on 2019-08-25.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Firebase
import Foundation

protocol SettingsViewModelDelegate: AnyObject {
    func didComplete(with result: Result<Bool, NetworkResponse>)
}

struct SettingsViewModel {
    
    var showUpdateConnectBank: Box<UpdateConnectBank?> = Box<UpdateConnectBank?>(nil)
    private let stripeService = StripeService()
    weak var delegate: SettingsViewModelDelegate?
    fileprivate let service: AccountService
    fileprivate let userService: UserService
    fileprivate let data: [SettingItem] =
        [
//            .automatedMessage,
            .shopNameAndPhone,
            .account,
//            .contentLibrary,
            .addTeamMembers,
            .connectBank,
            .updateBank,
            .logout
        ]
    
    var scheduledData: [ScheduledData] = []

    init(_ service: AccountService, _ userService: UserService = UserService()) {
        self.service = service
        self.userService = userService
        
        hasConnectedBank()
        
        scheduledData = UserSession.shared.shop?.scheduledData ?? [
            ScheduledData(weekDay: 0, isOpen: true, openTime: "9:00 AM", closeTime: "5:00 PM"),
            ScheduledData(weekDay: 1, isOpen: true, openTime: "9:00 AM", closeTime: "5:00 PM"),
            ScheduledData(weekDay: 2, isOpen: true, openTime: "9:00 AM", closeTime: "5:00 PM"),
            ScheduledData(weekDay: 3, isOpen: true, openTime: "9:00 AM", closeTime: "5:00 PM"),
            ScheduledData(weekDay: 4, isOpen: true, openTime: "9:00 AM", closeTime: "5:00 PM"),
            ScheduledData(weekDay: 5, isOpen: true, openTime: "9:00 AM", closeTime: "5:00 PM"),
            ScheduledData(weekDay: 6, isOpen: true, openTime: "9:00 AM", closeTime: "5:00 PM")
        ]
    }

    var count: Int {
        return data.count
    }

    func item(at indexPath: IndexPath) -> SettingItem {
        return data[indexPath.row]
    }
    
    func indexPath(for item: SettingItem) -> IndexPath? {
        guard let row = data.firstIndex(where: { $0 == item }) else { return nil }
        return IndexPath(row: row, section: 0)
    }
    
    func hasConnectedBank() {
        guard let shopID = UserSession.shared.shopID else {
            showUpdateConnectBank.value = .undefined
            return
        }
        let request = HasConnectedStripeRequest(shopID: shopID)
        stripeService.hasConnectedStripe(request: request) { result in
            switch result {
            case .success(let response):
                self.showUpdateConnectBank.value = response.hasConnected ? .update : .connect            
            case .failure(let error):
                self.showUpdateConnectBank.value = .undefined
                print("error:", error.localizedDescription)
            }
        }
    }

    static func viewModel() -> Self {
        return .init(AccountService(with: Authenticator.default))
    }
}

extension SettingsViewModel {
    func signOut() {
        removeAPNsToken()
        service.authorizer.signOut(true)
        PurchaseKit.reset()
        AnalyticsManager.logEvent(.logout)
        UserSettings().isEntitledToBaseSubscriptionInDebugMode = false
    }

    func inviteMember(with email: String) {
        let params: Parameters = ["email": email]
        userService.inviteUser(params: params) { (result) in
            self.delegate?.didComplete(with: result)
        }
    }
    
    private func removeAPNsToken() {
        if let userId = UserSession.shared.userID {
            userService.updateAPNsToken(token: "0", for: userId)
        }
        
        guard let shopId = UserSession.shared.shopID else {
            print("Error: Failed to get shop id.")
            return
        }
        
        Messaging.messaging().unsubscribe(fromTopic: shopId) { error in
            if let error = error {
                print("Unsubscribe from topic error: \(error.localizedDescription)")
                return
            }
            print("Unsubscribe from topic: \(shopId)")
        }
    }
}

extension SettingsViewModel {
    func createScheduledService(scheduledData: [ScheduledData], shopSize: Int?, completion: @escaping ScheduledServiceResponseHandler) {
        guard let shopID = UserSession.shared.shopID else { return }
        
        let request = CreateScheduledServiceRequest(
            shopId: shopID,
            scheduledData: scheduledData,
            shopSize: shopSize
        )

        userService.createScheduledService(with: request) { (success) in
            completion(.success(success))
            
            UserSettings().hasSetupAutomatedScheduling = true
        }
    }
}
