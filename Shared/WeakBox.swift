//
//  WeakBox.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2020-05-08.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

public final class WeakBox<T>: Equatable {
    public var value: T? {
        return instance as? T
    }
    private weak var instance: AnyObject?
    public init(_ instance: T) {
        self.instance = instance as AnyObject
    }

    public static func == (lhs: WeakBox<T>, rhs: WeakBox<T>) -> Bool {
        return lhs === rhs
    }
}
