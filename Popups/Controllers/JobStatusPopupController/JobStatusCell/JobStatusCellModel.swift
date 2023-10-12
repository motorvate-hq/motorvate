//
//  JobStatusCellModel.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

enum JobStatusCellModel: Int, CaseIterable {
    case completed = 0
    case inQueue
    case inProgress
    
    var jobStatus: Job.Status {
        switch self {
        case .completed:
            return .completed
        case .inQueue:
            return .inqueue
        case .inProgress:
            return .inProgress
        }
    }
    
    var title: String {
        switch self {
        case .completed:
            return "Completed"
        case .inQueue:
            return "In Queue"
        case .inProgress:
            return "In Progress"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .completed, .inQueue:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .inProgress:
            return UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .completed:
            return UIColor(red: 0.356, green: 0.567, blue: 0.017, alpha: 1)
        case .inQueue:
            return UIColor(red: 0.944, green: 0.32, blue: 0.311, alpha: 1)
        case .inProgress:
            return UIColor(red: 1, green: 0.683, blue: 0.076, alpha: 1)
        }
    }
    
    var iconSideInset: CGFloat {
        switch self {
        
        case .completed:
            return 17.7
        case .inQueue:
            return 22.2
        case .inProgress:
            return 15.3
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .completed:
            return R.image.jobStatusCompleted()
        case .inQueue:
            return R.image.jobStatusInQueue()
        case .inProgress:
            return R.image.jobStatusInProgress()
        }
    }
}
