//
//  TopViewControllerTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Lalamove
class TopViewControllerTest: XCTestCase {

    func testTopController() {
        let topController = UIApplication.getTopViewController() as? DeliveryListViewController
        XCTAssertNotNil(topController)

    }
}
