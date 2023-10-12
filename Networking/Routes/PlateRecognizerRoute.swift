//
//  PlateRecognizerRoute.swift
//  Motorvate
//
//  Created by Nikita Benin on 19.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

enum PlateRecognizerRoute {
    case plateReader(request: PlateReaderRequest)
}
    
extension PlateRecognizerRoute: EndPointType {
    var path: String {
        switch self {
        case .plateReader:
            return "v1/plate-reader/"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .plateReader:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .plateReader(let request):
            return .requestParameters(bodyParameters: request.dictionary, urlParameters: nil)
        }
    }
}
