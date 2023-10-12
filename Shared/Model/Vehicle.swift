//
//  Vehicle.swift
//  Motorvate
//
//  Created by Emmanuel on 3/4/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

public struct Vehicle: Codable {
    enum CodingKeys: String, CodingKey {
        case make
        case model = "carModel"
        case year = "modelYear"
        case imageURL = "imageUrl"
        case vin
    }

    public let make: String
    public let model: String
    public let year: String
    public let vin: String
    public var imageURL: URL?
    public var description: String {
        return "\(year) \(make) \(model)"
    }

    init(make: String, model: String, year: String, imageURL: URL? = nil) {
        self.make = make
        self.model = model
        self.year = year
        self.vin = ""
        self.imageURL = imageURL
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        make = try values.decodeIfPresent(String.self, forKey: .make) ?? ""
        model = try values.decodeIfPresent(String.self, forKey: .model) ?? ""
        year = try values.decodeIfPresent(String.self, forKey: .year) ?? ""
        imageURL = try values.decodeIfPresent(URL.self, forKey: .imageURL)
        vin = try values.decodeIfPresent(String.self, forKey: .vin) ?? ""
    }
}
