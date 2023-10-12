//
//  AppDelegate.swift
//  Motorvate
//
//  Created by Emmanuel on 1/21/18.
//  Copyright © 2018 motorvate. All rights reserved.
//

import Firebase
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseMessaging

import UIKit
import RevenueCat

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Variables
    var applicationCoordinator: ApplicationCoordinator?
    private var userService = UserService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        _configureFirebase()
        _configurePurchaseSDK()
        _setupNavigationBarAppearance()

        UIApplication.shared.applicationIconBadgeNumber = UserSettings().totalNotificationsCounter
        
        applicationCoordinator = ApplicationCoordinator(window, Authenticator.default)
        applicationCoordinator?.start()
        
        Messaging.messaging().delegate = self

        return true
    }
}

// MARK: - UserNotifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        UserSettings().deviceToken = token
        if let userId = UserSession.shared.userID {
            userService.updateAPNsToken(token: token, for: userId)
        } else {
            // Do some logging here if user was not logged in
            print("User was not logged in")
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationRepository.shared.didReceiveRemoteNotification(userInfo: userInfo)
        completionHandler(.newData)
    }
}

extension AppDelegate {
    private func _setupNavigationBarAppearance() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: AppFont.archivo(.regular, ofSize: 19), NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        let backButtonImage = R.image.backbutton()
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UINavigationBar.appearance().tintColor = .black
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    private func _configureFirebase() {
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
    }

    private func _configurePurchaseSDK() {
        let configuration = PurchaseKit.Configuration(apiKey: Environment.revenueCatAPI, level: .verbose, delegate: self)
        MLogger.log(.info, configuration)
        PurchaseKit.configure(configuration)
    }
}

// MARK: - PurchasesDelegate
extension AppDelegate: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        MLogger.log(.info, "Purchases, receivedUpdated customerInfo \(customerInfo)")
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration FCMToken: \(String(describing: fcmToken))")
        subscribeToShopId()
    }
    
    func subscribeToShopId() {
        guard let shopId = UserSession.shared.shopID else {
            print("Error: Failed to get shop id.")
            return
        }
        
        Messaging.messaging().subscribe(toTopic: shopId) { error in
            if let error = error {
                print("Subscribe to topic error: \(error.localizedDescription)")
                return
            }
            print("Subscribed to topic: \(shopId)")
        }
    }
}
