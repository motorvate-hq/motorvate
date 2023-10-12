//
//  CarsXERoute.swift
//  Motorvate
//
//  Created by Nikita Benin on 19.01.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation

enum CarsXERoute {
    case plateDecoder(request: PlateDecoderRequest)
}
    
extension CarsXERoute: EndPointType {
    var path: String {
        switch self {
        case .plateDecoder:
            return "platedecoder"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .plateDecoder:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .plateDecoder(let request):
            return .requestParameters(bodyParameters: nil, urlParameters: request.dictionary)
        }
    }
}
