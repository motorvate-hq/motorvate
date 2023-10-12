//
//  Store.swift
//  Motorvate
//
//  Created by Emmanuel on 9/11/22.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation
import RevenueCat

enum PurchaseResult {
    case success(PurchaseKit.EntitlementTier)
    case error(String)
    case cancelled
    case unkown
}

final public class PurchaseKit {
    typealias PurchasableProduct = [String: Package]
    public struct Configuration {
        let apiKey: String
        let level: MLogger.Level
        let delegate: PurchasesDelegate?
    }

    static func configure(_ configuration: Configuration) {
        Purchases.logLevel = configuration.level.log
        Purchases.configure(withAPIKey: configuration.apiKey)
        Purchases.shared.delegate = configuration.delegate
    }

    static func fetchProducts(for entitlement: EntitlementTier) async -> PurchasableProduct? {
        return await withCheckedContinuation { continuation in
            Purchases.shared.getOfferings { offerrings, _ in
                let offering = offerrings?.offering(identifier: entitlement.offeringIdentifier)
                guard let _offering = offering  else {
                    continuation.resume(returning: nil)
                    return
                }

                var products = PurchasableProduct()
                for item in _offering.availablePackages {
                    products[item.identifier] = item
                }
                continuation.resume(returning: products)
            }
        }
    }

    static func purchase(_ package: Package) async -> PurchaseResult {
        return await withCheckedContinuation { continuaton in
            Purchases.shared.purchase(package: package) { transaction, info, error, userCancelled in
                if userCancelled {
                    continuaton.resume(returning: .cancelled)
                    return
                }

                if let _error = error {
                    continuaton.resume(returning: .error(_error.localizedDescription))
                    return
                }

                guard let _info = info?.entitlements[PurchaseKit.EntitlementTier.base.rawValue], _info.isActive else {
                    continuaton.resume(returning: .unkown)
                    return
                }

                continuaton.resume(returning: .success(PurchaseKit.EntitlementTier.base))
            }
        }
    }

    static func restore() async -> PurchaseResult {
        return await withCheckedContinuation { continuation in
            Purchases.shared.restorePurchases { info, error in
                guard let _error = error else {
                    continuation.resume(returning: .success(EntitlementTier.base))
                    return
                }

                continuation.resume(returning: .error(_error.localizedDescription))
            }
        }
    }

    static func isEntitled(to entitlement: EntitlementTier = .base) async -> Bool {
        guard !SubscriptionViewModel.isDebugMode else { return UserSettings().isEntitledToBaseSubscriptionInDebugMode }
        return await withCheckedContinuation { continuation in
            Purchases.shared.getCustomerInfo { info, _ in
                let isEntitled = (info?.entitlements.all[entitlement.rawValue]?.isActive == true)
                continuation.resume(returning: isEntitled)
            }
        }
    }


    static func set(appUserId: String) {
        Task {
            try await Purchases.shared.logIn(appUserId)
        }
    }

    static func reset() {
        Task {
            try await Purchases.shared.logOut()
        }
    }
}

extension PurchaseKit {
    enum EntitlementTier: String {
        case base = "MVM_SUB_MONTHLY1"
    }
}

extension PurchaseKit.EntitlementTier {
    var offeringIdentifier: String {
        switch self {
        case .base: return "Service Boost Base Tier"
        }
    }
}

// MARK: MLogger.Level
extension MLogger.Level {
    fileprivate var log: LogLevel {
        switch self {
        case .info:
            return .debug
        case .error:
            return .error
        case .verbose:
            return .verbose
        }
    }
}

// Helper
extension Package {
    func toProductInfo() -> ProductInfo {
        return ProductInfo(
            identifier: identifier,
            title: storeProduct.localizedTitle,
            descrption: storeProduct.localizedDescription,
            localizedPriceString: localizedPriceString,
            localizedIntroductoryPrice: localizedIntroductoryPriceString
        )
    }
}
