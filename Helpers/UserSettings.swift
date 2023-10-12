//
//  UserSettings.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-02-02.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

private extension UserSettings {
    enum Key: String, CaseIterable {
        case deviceToken
        case didShowInquiryFormsPopup
        case hasSeenWalkthroughFlow
        case inquiriesNotificationsCounter
        case messagesNotificationsCounter
        case hasSeenEstimateWalkthroughFlow
        case hasSeenPartnerAffirm
        case hasSeenConnectBank
        case hasSeenAutomateInquiriesVideo
        case hasSeenHowOnboardVideo
        case depositPaidNotificationsCounter
        case isEntitledToBaseSubscriptionInDebugMode
        case hasSetupAutomatedScheduling
    }
}

final class UserSettings {
    private let defaults = UserDefaults.standard

    var deviceToken: String? {
        get {
            return defaults.string(forKey: Key.deviceToken.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.deviceToken.rawValue)
        }
    }
    
    var didShowInquiryFormsPopup: Bool {
        get {
            return defaults.bool(forKey: Key.didShowInquiryFormsPopup.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.didShowInquiryFormsPopup.rawValue)
        }
    }

    var hasSeenWalkthroughFlow: Bool {
        get {
            return defaults.bool(forKey: Key.hasSeenWalkthroughFlow.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.hasSeenWalkthroughFlow.rawValue)
        }
    }
    
    var inquiriesNotificationsCounter: Int {
        get {
            return defaults.integer(forKey: Key.inquiriesNotificationsCounter.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.inquiriesNotificationsCounter.rawValue)
        }
    }
    
    var messagesNotificationsCounter: Int {
        get {
            return defaults.integer(forKey: Key.messagesNotificationsCounter.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.messagesNotificationsCounter.rawValue)
        }
    }
    
    var hasSeenEstimateWalkthroughFlow: Bool {
        get {
            return defaults.bool(forKey: Key.hasSeenEstimateWalkthroughFlow.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.hasSeenEstimateWalkthroughFlow.rawValue)
        }
    }
    
    var hasSeenPartnerAffirm: Bool {
        get {
            return defaults.bool(forKey: Key.hasSeenPartnerAffirm.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.hasSeenPartnerAffirm.rawValue)
        }
    }
    
    var hasSeenConnectBank: Bool {
        get {
            return defaults.bool(forKey: Key.hasSeenConnectBank.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.hasSeenConnectBank.rawValue)
        }
    }
    
    var hasSeenAutomateInquiriesVideo: Bool {
        get {
            return defaults.bool(forKey: Key.hasSeenAutomateInquiriesVideo.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.hasSeenAutomateInquiriesVideo.rawValue)
        }
    }
    
    var hasSeenHowOnboardVideo: Bool {
        get {
            return defaults.bool(forKey: Key.hasSeenHowOnboardVideo.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.hasSeenHowOnboardVideo.rawValue)
        }
    }
    
    var depositPaidNotificationsCounter: Int {
        get {
            return defaults.integer(forKey: Key.depositPaidNotificationsCounter.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.depositPaidNotificationsCounter.rawValue)
        }
    }

    var isEntitledToBaseSubscriptionInDebugMode: Bool {
        get {
            return defaults.bool(forKey: Key.isEntitledToBaseSubscriptionInDebugMode.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.isEntitledToBaseSubscriptionInDebugMode.rawValue)
        }
    }
    
    var hasSetupAutomatedScheduling: Bool {
        get {
            return defaults.bool(forKey: Key.hasSetupAutomatedScheduling.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.hasSetupAutomatedScheduling.rawValue)
        }
    }
    
    var notificationsCenterCounter: Int {
        return [
            didShowInquiryFormsPopup,
            hasSeenEstimateWalkthroughFlow,
            hasSeenPartnerAffirm,
            hasSeenConnectBank,
            hasSeenAutomateInquiriesVideo,
            hasSeenHowOnboardVideo
        ].map({ $0 ? 0 : 1 }).reduce(0, +) + depositPaidNotificationsCounter
    }
    
    var totalNotificationsCounter: Int {
        return notificationsCenterCounter + inquiriesNotificationsCounter + messagesNotificationsCounter
    }
    
    func resetDefaults() {
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != Key.hasSeenWalkthroughFlow.rawValue {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
