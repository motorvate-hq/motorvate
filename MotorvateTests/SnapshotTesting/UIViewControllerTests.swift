//
//  UIViewControllerTests.swift
//  MotorvateTests
//
//  Created by Nikita Benin on 30.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import SnapshotTesting
import XCTest

extension XCTestCase {
    func verifyViewController(_ viewController: UIViewController?, isRecording: Bool = false, wait: CGFloat = 0) {
        guard let viewController = viewController else { return }
        let devices: [String: ViewImageConfig] = [
            "iPhoneXr": .iPhoneXr,
            "iPhoneX": .iPhoneX,
            "iPhone8": .iPhone8
        ]
            
        let results = devices.map { device in
            verifySnapshot(
                matching: viewController,
                as: .wait(for: wait, on: .image(on: device.value)),
                named: "\(device.key)",
                record: isRecording,
                testName: getTestName(viewController)
            )
        }
        results.forEach { XCTAssertNil($0) }
    }
    
    private func getTestName(_ viewController: UIViewController) -> String {
        if let navigationController = viewController as? UINavigationController,
        let firstViewController = navigationController.viewControllers.first {
            return "\(String(describing: type(of: firstViewController.self)))"
        }
        return "\(String(describing: type(of: viewController.self)))"
    }
}
