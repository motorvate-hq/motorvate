//
//  AccountSettingsViewModel.swift
//  Motorvate
//
//  Created by Nikita Benin on 06.09.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation
import Combine

class AccountSettingsViewModel {

    @Published private(set) var accountDeletionComplete = false
    private let service: UserService

    init(_ service: UserService = UserService()) {
        self.service = service
    }
    
    private let data: [AccountSettingItem] =
        [
//            .changeEmail,
//            .connectToAccounts,
            .changePassword,
//            .development,
            .deleteAccount
        ]
    
    var count: Int {
        return data.count
    }

    func item(at indexPath: IndexPath) -> AccountSettingItem {
        return data[indexPath.row]
    }

    func delete(userId: String) {
        Task {
            accountDeletionComplete = await service.deleteAccount(for: userId)
        }
    }

    func signOut() {
        let viewModel = SettingsViewModel.viewModel()
        viewModel.signOut()
    }
}
