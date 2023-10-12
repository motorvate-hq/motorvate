//
//  ChangePasswordViewModel.swift
//  Motorvate
//
//  Created by Emmanuel on 9/21/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

struct ChangePasswordViewModel {

    private let service: AccountService
    
    init(_ service: AccountService) {
        self.service = service
    }
}

extension ChangePasswordViewModel {
    struct PasswordEntity {
        let current: String
        let proposed: String
    }

    func changePassword(_ entity: PasswordEntity, completion: @escaping (Bool) -> Void) {
        service.authorizer.changePassword(currentPassword: entity.current, newPassword: entity.proposed) { (result) in
            completion(result)
        }
    }
}
