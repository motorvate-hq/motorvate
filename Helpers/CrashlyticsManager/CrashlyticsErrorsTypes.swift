//
//  CrashlyticsErrorsTypes.swift
//  Motorvate
//
//  Created by Nikita Benin on 26.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

enum CrashlyticsErrorsTypes {
    case forgotPasswordRequestError(description: String, message: String)
    case fieldsNilValidationError(fields: [String])
    case apiError(error: NSError)
    
    var errorName: String {
        switch self {
        case .forgotPasswordRequestError:
            return "forgot_password_request_error"
        case .fieldsNilValidationError:
            return "fieldsNilValidationError"
        case .apiError:
            return "apiError"
        }
    }
    
    var userInfo: [String: String]? {
        switch self {
        case .forgotPasswordRequestError(let description, let message):
            return [
                "error": errorName,
                "localizedDescription": description,
                "message": message
            ]
        case .fieldsNilValidationError(let fields):
            let fieldsString = "\(fields.map({ "\($0)" }))"
            return [
                "error": errorName,
                "message": "Fields validated: \(fieldsString)"
            ]
        case .apiError(let err):
            return [
                "error": errorName,
                "localizedDescription": err.description,
                "message": err.localizedDescription
            ]
        }
    }
}
