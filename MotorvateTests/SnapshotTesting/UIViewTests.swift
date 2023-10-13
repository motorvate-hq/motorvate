//
//  UIViewTests.swift
//  MotorvateTests
//
//  Created by Nikita Benin on 30.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import SnapshotTesting
import XCTest

extension XCTestCase {
    func verifyView(view: UIView, state: String = "", isRecording: Bool = false) {
        let result = verifySnapshot(
            matching: view,
            as: .image,
            named: state,
            testName: "\(String(describing: type(of: view.self)))"
        )
        XCTAssertNil(result)
    }
}
