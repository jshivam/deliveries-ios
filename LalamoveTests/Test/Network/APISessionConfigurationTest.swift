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
    func testBaseURL() {
        XCTAssertEqual(APISessionConfiguration.init().baseURL, "https://mock-api-mobile.dev.lalamove.com")
    }
}
