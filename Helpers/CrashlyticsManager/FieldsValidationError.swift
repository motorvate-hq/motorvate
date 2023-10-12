//
//  FieldsValidationError.swift
//  Motorvate
//
//  Created by Nikita Benin on 26.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

class FieldsValidationError: Error, LocalizedError {
    var description: String {
        return "Something went wrong. Error: MV1"
    }
    
    var errorDescription: String? {
        return self.description
    }
}
