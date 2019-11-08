//
//  APISessionConfigurationTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Lalamove
class APISessionConfigurationTest: XCTestCase {
    var config: APISessionConfiguration! = APISessionConfiguration.init()

    func testBaseURL() {
        XCTAssertEqual(config.baseURL, "https://mock-api-mobile.dev.lalamove.com")
    }

    override func tearDown() {
        config = nil
    }
}
