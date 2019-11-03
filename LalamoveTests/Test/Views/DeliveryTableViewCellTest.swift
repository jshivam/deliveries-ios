//
//  DeliveryTableViewCellTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Lalamove

class DeliveryTableViewCellTest: XCTestCase {

    var cell: DeliveryTableViewCell!

    override func setUp() {
        cell = DeliveryTableViewCell.init(style: .default, reuseIdentifier: "cell")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
