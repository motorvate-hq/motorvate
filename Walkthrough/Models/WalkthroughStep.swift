//
//  WalkthroughStep.swift
//  Motorvate
//
//  Created by Nikita Benin on 16.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

enum WalkthroughStep: Int, CaseIterable {
    case scanVin
    case updateJobDetails
    case enterJobDetails
    case editJobDetails
    case tapMessages
    case sendInvoice
    case confirmInvoice
    case updateStatus
    case finishTutorial
    case closeTutorial
    
    var text: String {
        switch self {
        case .scanVin:
            return "Scan customer VIN to create profiles. We can determine the make / model within seconds and provide an image for almost every vehicle after 2009."
        case .updateJobDetails:
            return "Edit or update the job details and send for customer confirmation."
        case .enterJobDetails:
            return "Enter any item description and price. For example “car repair” and “$350”."
        case .editJobDetails:
            return "Swipe job details to edit price, labor or service."
        case .tapMessages:
            return "Keep your customer updated throughout the service and request payments from your customers with one tap."
        case .sendInvoice:
            return "Send updates of the service and payments requests to your customers. You will recieve a notification once complete."
        case .confirmInvoice:
            return "When the customer confirms the invoice, you will a receive notification."
        case .updateStatus:
            return "We store all your previous jobs and invoices so you can go paperless."
        case .finishTutorial:
            return "Congratulations! You have successfully finished the tutorial. Click \"completed\" to finish the test job and connect your bank or card. "
        case .closeTutorial:
            return ""
        }
    }
    
    var showBackButton: Bool {
        switch self {
        case .scanVin:
            return false
        default:
            return true
        }
    }
    
    var showNextButton: Bool {
        switch self {
        case .scanVin, .updateJobDetails, .enterJobDetails, .tapMessages, .sendInvoice, .updateStatus, .finishTutorial:
            return false
        case .editJobDetails, .confirmInvoice, .closeTutorial:
            return true
        }
    }
}
