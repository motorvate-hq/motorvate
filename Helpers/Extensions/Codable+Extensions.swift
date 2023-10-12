//
//  Codable+Extensions.swift
//  Motorvate
//
//  Created by Nikita Benin on 22.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
