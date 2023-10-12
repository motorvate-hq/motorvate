//
//  ChatJobSelectorViewModel.swift
//  Motorvate
//
//  Created by Nikita Benin on 21.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

class ChatJobSelectorViewModel {
    
    // MARK: Variables
    private var chatHistory: ChatHistory?
    private var cellModels: [ChatJobSelectorCellModel] = []
    
    // MARK: Lifecycle
    init(chatHistory: ChatHistory?) {
        self.chatHistory = chatHistory
        
        guard let inquiries = chatHistory?.inquiries else { return }
        for inquiry in inquiries {
            cellModels.append(
                ChatJobSelectorCellModel(id: inquiry.id, isInquiry: true, imageURL: nil, carTitle: inquiry.model)
            )
        }
        
        guard let jobs = chatHistory?.jobs else { return }
        for job in jobs {
            cellModels.append(
                ChatJobSelectorCellModel(id: job.jobID, isInquiry: false, imageURL: job.vehicle?.imageURL, carTitle: job.vehicle?.description)
            )
        }
    }
    
    func numberOfItems() -> Int {
        return cellModels.count
    }
    
    func itemForIndex(index: Int) -> ChatJobSelectorCellModel {
        return cellModels[index]
    }
}
