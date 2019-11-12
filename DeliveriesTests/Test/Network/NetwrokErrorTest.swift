//
//  NetwrokErrorTest.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries

class NetwrokErrorTest: XCTestCase {

    let noInternetError = NetworkError.noInternet
    let apiError = NetworkError.apiError
    let noData = NetworkError.noData

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkErrors() {
        XCTAssertEqual(noInternetError.localizedDescription, NSLocalizedString("The Internet connection appears to be offline", comment: ""))
        XCTAssertEqual(apiError.localizedDescription, NSLocalizedString("Oops! Something went wrong!", comment: ""))
        XCTAssertEqual(noData.localizedDescription, NSLocalizedString("We don't have any data to show now!", comment: ""))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
