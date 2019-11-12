//
//  APISessionConfigurationTest.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries
class APISessionConfigurationTest: XCTestCase {
    var config: APISessionConfiguration! = APISessionConfiguration.init()

    func testBaseURL() {
        XCTAssertEqual(config.baseURL, "https://mock-api-mobile.dev.lalamove.com")
    }

    override func tearDown() {
        config = nil
    }
}
