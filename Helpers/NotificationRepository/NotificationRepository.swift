//
//  NotificationRepository.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-05-08.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public protocol NotificationRepositoryListener: AnyObject {
    func receivedNotification(type: APNsNotificationType)
    func receivedNotificationInteraction(type: APNsNotificationType)
}

public final class NotificationRepository: NSObject {

    public enum NotificationSettingsStatus {
        case notDetermined
        case authorized
        case denied
        case unknown
    }

    public static let shared = NotificationRepository()

    private var listeners: [WeakBox<NotificationRepositoryListener>] = []

    private let notificationCenter = UNUserNotificationCenter.current()

    override init() {
        super.init()

        notificationCenter.delegate = self
    }

    public func addListener(_ listener: NotificationRepositoryListener) {
        let boxedListener = WeakBox(listener)
        if !listeners.contains(boxedListener) {
            listeners.append(boxedListener)
        }
    }

    // MARK: - Authorization
    public func getAuthorizationStatus(_ completionHandler: @escaping (NotificationSettingsStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    completionHandler(.notDetermined)
                case .authorized, .ephemeral:
                    completionHandler(.authorized)
                case .denied, .provisional:
                    completionHandler(.denied)
                @unknown default:
                    completionHandler(.unknown)
                }
            }
        }
    }

    public func requestAuthorization(_ completionHandler: ((Result<Bool, Error>) -> Void)? = nil) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                if let error = error {
                    completionHandler?(.failure(error))
                    return
                } else {
                    completionHandler?(.success(granted))
                    return
                }
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationRepository: UNUserNotificationCenterDelegate {
    
    public func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        
        // Action when notificiation is received and app is in background
        print("NotificationRepository didReceiveRemoteNotification userInfo", userInfo)
        if let notification = APNsNotification(userInfo: userInfo), let type = notification.type {
            listeners.forEach({ $0.value?.receivedNotification(type: type) })
        }
    }
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        // Action when user taps or interacts with notificiation
        let userInfo = response.notification.request.content.userInfo
        print("NotificationRepository userNotificationCenter didReceive userInfo", userInfo)
        
        if let notification = APNsNotification(userInfo: userInfo), let type = notification.type {
            listeners.forEach({ $0.value?.receivedNotificationInteraction(type: type) })
        }
        
        completionHandler()
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {

        // Action when notificiation is presented and app is in foreground
        let userInfo = notification.request.content.userInfo
        print("NotificationRepository userNotificationCenter willPresent userInfo", userInfo)
        if let notification = APNsNotification(userInfo: userInfo), let type = notification.type {
            listeners.forEach({ $0.value?.receivedNotification(type: type) })
        }
                
        completionHandler([.alert, .sound])
    }
}
