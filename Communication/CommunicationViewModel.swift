//
//  CommunicationViewMdodel.swift
//  Motorvate
//
//  Created by Emmanuel on 11/10/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

final class CommunicationViewModel {

    enum Action {
        case reloadData
        case setLoadingMode(isOn: Bool)
        case showPlaceholder
        case showAlert(error: Error)
    }

    var didReceiveAction: ((Action) -> Void)?

    var isVisible: Bool = false
    
    private var chatHistories: [ChatHistory] = [] {
        didSet {
            didReceiveAction?(chatHistories.isEmpty ?  .showPlaceholder : .reloadData)
        }
    }

    func fetchChatHistories() {
        guard let shopId = UserSession.shared.shop?.id else { return }
        didReceiveAction?(.setLoadingMode(isOn: isVisible))
        ChatService().getHistories(shopID: shopId) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.didReceiveAction?(.setLoadingMode(isOn: false))
                switch result {
                case .success(let histories):
                    strongSelf.chatHistories = histories
                case .failure(let error):
                    strongSelf.didReceiveAction?(.showAlert(error: error))
                    print(error)
                }
            }
        }
    }

    var count: Int {
        return chatHistories.count
    }

    func item(at indexPath: IndexPath) -> ChatHistory {
        return chatHistories[indexPath.item]
    }

    func isLastItem(at indexPath: IndexPath) -> Bool {
        return chatHistories.count == (indexPath.row + 1)
    }
}
