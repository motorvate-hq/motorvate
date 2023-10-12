//
//  CrashlyticsManager.swift
//  Motorvate
//
//  Created by Nikita Benin on 05.08.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import FirebaseCrashlytics

class CrashlyticsManager {
    static func recordError(_ type: CrashlyticsErrorsTypes, error: NSError? = nil) {
        let crashlyticsError = NSError(
            domain: error?.domain ?? "",
            code: error?.code ?? -1,
            userInfo: type.userInfo
        )
        print("CrashlyticsManager - record error:", crashlyticsError.localizedDescription)
        Crashlytics.crashlytics().record(error: crashlyticsError)
    }
 }
