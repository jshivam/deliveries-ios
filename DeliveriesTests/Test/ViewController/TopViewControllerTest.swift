//
//  TopViewControllerTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries
class TopViewControllerTest: XCTestCase {

    func testTopController() {
        if UIApplication.getTopViewController() as? DeliveryListViewController != nil {
            XCTAssert(true)
        } else if UIApplication.getTopViewController() as? UIAlertController  != nil {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
}
