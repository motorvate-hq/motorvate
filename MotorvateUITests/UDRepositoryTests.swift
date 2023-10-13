//
//  UDRepositoryTests.swift
//  MotorvateTests
//
//  Created by Emmanuel on 3/4/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

@testable import Motorvate
import XCTest

class UDRepositoryTests: XCTestCase {
    let testUser = TestUser(uname: "Emmanuel", lname: "Attoh")

    func testGetItem() {
        let valueKey = "valueKey"
        guard let value = testUser.dictionaryValue else {
            XCTFail("Failed to retrieve dictionary valu")
            return
        }

        UDRepository.shared.insert(item: value, for: valueKey)

        guard let user = UDRepository.shared.getItem(TestUser.self, for: valueKey) else {
            assertionFailure()
            return
        }

        XCTAssertNotNil(user)
        XCTAssertEqual(user.uname, "Emmanuel", "Expected does not match value")
        XCTAssertEqual(user.lname, "Attoh", "Expected does not match value")
    }
}

struct TestUser: Codable {
    let uname: String
    let lname: String

    var dictionaryValue: Data? {
        let value: Data? = """
        {
            "uname": "\(uname)",
            "lname": "\(lname)"
        }
        """.data(using: .utf8)
        return value
    }
}
