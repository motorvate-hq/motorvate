//
//  EstimateWalkthroughCellType.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

enum EstimateWalkthroughCellType: Int, CaseIterable {
    case stepOne
    case stepTwo
    case stepThree
    case stepFour
    case stepFive
    
    var backgroundTopImage: UIImage? {
        switch self {
        case .stepOne:     return R.image.stepOneTop()
        case .stepTwo:     return R.image.stepTwoTop()
        case .stepThree:   return R.image.stepFourTop()
        case .stepFour:    return R.image.stepFiveTop()
        case .stepFive:    return R.image.stepSixTop()
        }
    }
    
    var backgroundBottomImage: UIImage? {
        switch self {
        case .stepOne:     return R.image.stepOneBottom()
        case .stepTwo:     return R.image.stepTwoBottom()
        case .stepThree:   return R.image.stepTwoBottom()
        case .stepFour:    return nil
        case .stepFive:    return R.image.stepSixBottom()
        }
    }
}
