//
//  UDRepository.swift
//  Motorvate
//
//  Created by Emmanuel on 3/1/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

class UDRepository {

    static let shared = UDRepository()

    func insert(item: Data, for key: String) {
        UserDefaults.standard.set(item, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func getItem<T>(_ type: T.Type, for key: String) -> T? where T: Decodable {
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            } catch let error as NSError {
                print("Logger UDRepository Failed to decode \(type) error \(error)")
                return nil
            }
        }
        return nil
    }
}
