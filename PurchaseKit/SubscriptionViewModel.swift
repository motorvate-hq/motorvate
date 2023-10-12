//
//  SubscriptionViewModel.swift
//  Motorvate
//
//  Created by Emmanuel on 9/5/22.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Combine

class SubscriptionViewModel: ObservableObject {
    static var isDebugMode: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    private static let montlyKey = "$rc_monthly"

    @Published var products: PurchaseKit.PurchasableProduct = [:]
    @Published var transactionResult: PurchaseResult = .unkown

    var productInfo: ProductInfo? {
        guard let item = products[Self.montlyKey] else { return nil }
        return ProductInfo(
            identifier: item.identifier,
            title: item.storeProduct.localizedTitle,
            descrption: item.storeProduct.localizedDescription,
            localizedPriceString: item.localizedPriceString,
            localizedIntroductoryPrice: item.localizedIntroductoryPriceString
        )
    }

    func fetchProducts(_ entitlement: PurchaseKit.EntitlementTier) {
        Task {
            let products = await PurchaseKit.fetchProducts(for: entitlement)
            self.products = products ?? [:]
        }
    }

    func purchase() {
        Task {
            guard let package = products[Self.montlyKey] else { return }
            transactionResult = await PurchaseKit.purchase(package)
        }
    }

    func restorePurchase() {
        Task {
            transactionResult = await PurchaseKit.restore()
        }
    }
}
