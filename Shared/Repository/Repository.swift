//
//  Repository.swift
//  Motorvate
//
//  Created by Emmanuel on 3/1/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype Element

    func insert(item: Element, for key: String)
    func getItem(for key: String) -> Element?
}
