//
//  AnalyticsEventsTypes.swift
//  Motorvate
//
//  Created by Nikita Benin on 02.08.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

enum AnalyticsEventsTypes {
    
    // MARK: - Login, Registration flow
    case login
    case createdAccount
    case confirmedAccount
    case forgotPassword
    case startedWalkThrough
    case finishedWalkThrough
    case logout

    // MARK: - New jobs, inquiries
    case newInquiry
    case newDropOff
    case startOnboard

    // MARK: - Job statuses
    case jobStatusCompleted
    case jobStatusInProgress
    case jobStatusInQueue

    // MARK: - Chat
    case invoiceSent
    case messageSent
    
    // MARK: - Job Services
    case jobServiceAdded(price: Double?)
    case jobServiceChanged(price: Double?)
    case jobServiceDeleted(price: Double?)

    // MARK: - Settings
    case passwordChanged
    case teamMemberAdded
    
    // MARK: - Tutorial videos
    case watchInquiryTutorial
    case watchOnboardTutorial
    
    var eventName: String {
        switch self {
        case .login:                return "login"
        case .createdAccount:       return "created_account"
        case .confirmedAccount:     return "confirmed_account"
        case .forgotPassword:       return "forgot_password"
        case .startedWalkThrough:   return "started_walk_through"
        case .finishedWalkThrough:  return "finished_walk_through"
        case .logout:               return "logout"
            
        case .newInquiry:           return "new_inquiry"
        case .newDropOff:           return "new_dropoff"
        case .startOnboard:         return "start_onboard"
            
        case .jobStatusCompleted:   return "job_status_completed"
        case .jobStatusInProgress:  return "job_status_inProgress"
        case .jobStatusInQueue:     return "job_status_inQueue"
            
        case .invoiceSent:          return "invoice_sent"
        case .messageSent:          return "message_sent"
            
        case .jobServiceAdded:      return "job_service_added"
        case .jobServiceChanged:    return "job_service_changed"
        case .jobServiceDeleted:    return "job_service_deleted"
            
        case .passwordChanged:      return "password_changed"
        case .teamMemberAdded:      return "team_member_added"
        case .watchInquiryTutorial: return "watch_inquiry_tutorial"
        case .watchOnboardTutorial: return "watch_onboard_tutorial"
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .jobServiceAdded(let price),
             .jobServiceChanged(let price),
             .jobServiceDeleted(let price):
            if let price = price {
                return ["price": "\(price)"]
            }
            return nil
        default:
            return nil
        }
    }
}
