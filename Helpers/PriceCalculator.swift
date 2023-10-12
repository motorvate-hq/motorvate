//
//  PriceCalculator.swift
//  Motorvate
//
//  Created by Nikita Benin on 25.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

class PriceCalculator {
    static func calculateExpectedTotalPrice(price: Double, includeFee: Bool) -> Double {
        guard price > 0 else { return 0 }
        let expectedTotal: Double = !includeFee ? ((price + 0.3) / (1 - 0.049)) : price
        return expectedTotal
    }
    
    static func calculateFeeForPrice(price: Double, includeFee: Bool) -> Double {
        guard price > 0 else { return 0 }
        let expectedTotal: Double = !includeFee ? ((price + 0.3) / (1 - 0.049)) : price
        let fee: Double = (expectedTotal * 4.9 + 30) / 100
        return fee
    }
}
