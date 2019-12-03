//
//  TableViewFooterLoaderTest.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries

class TableViewFooterLoaderTest: XCTestCase {

    var tableViewMock: TableViewMock!

    override func setUp() {
        tableViewMock = TableViewMock()
    }

    override func tearDown() {
        tableViewMock = nil
    }

    func testShowFooter() {
        tableViewMock.showFooterLoader()
        let view = tableViewMock.tableView.tableFooterView as? LoaderView
        XCTAssertNotNil(view)
        XCTAssert(view!.loader.isAnimating)
    }

    func testHideFooter() {
        tableViewMock.hideFooterLoader()
        let view = tableViewMock.tableView.tableFooterView
        XCTAssertNotNil(view)
        XCTAssertEqual(view!.frame, CGRect.zero)
    }

}
