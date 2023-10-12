//
//  Environment.swift
//  Motorvate
//
//  Created by Emmanuel on 5/2/18.
//  Copyright © 2018 motorvate. All rights reserved.
//

import Foundation

public enum Environment {
    private enum _Keys {
        static let baseURL = "BASE_URL"
        static let webURL = "WEB_URL"
        static let congnito = "COGNITO_CONFIG"
        static let revenueCat = "REVENUE_CAT_API_KEY"
    }

    private static func _info(for key: String ) -> Any? {
        guard let infoDictionary = Bundle.main.infoDictionary else { fatalError("Info.plist file is not found") }
        return infoDictionary[key]
    }

    static var baseURL: URL {
        guard let urlString = _info(for: _Keys.baseURL) as? String else { fatalError("BASE_URL is not set in info.plist") }
        guard let url = URL(string: urlString) else { fatalError("BASE_URL is invalid") }

        return url
    }
    
    static var webURL: URL {
        guard let urlString = _info(for: _Keys.webURL) as? String else { fatalError("WEB_URL is not set in info.plist") }
        guard let url = URL(string: urlString) else { fatalError("WEB_URL is invalid") }

        return url
    }

    static var revenueCatAPI: String {
        guard let key = _info(for: _Keys.revenueCat) else {
            fatalError("\(_Keys.revenueCat) is not set in info.plist")
        }
        guard let apiKey = key as? String else {
            fatalError("Unable to conver \(key) to String")
        }

        return apiKey
    }

    static func congitoConfig(for key: String) -> String {
        guard let configs = _info(for: _Keys.congnito) as? [String: Any] else { fatalError("\(_Keys.congnito) is not set in info.plist") }
        guard let config = configs[key] as? String else { fatalError("\(key) is not set for \(_Keys.congnito)") }

        return config
    }
    
    static let plateRecognizerAuthToken = "Token aa6963e19a005926ed213b701cc20f850aa7ec6b"
    static let carsXeAuthToken = "4darjt5zq_1wjqntiv9_2dng63lrr"
}
