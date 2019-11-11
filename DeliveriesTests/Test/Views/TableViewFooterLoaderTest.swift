//
//  TableViewFooterLoaderTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 02/11/19.
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
        if let view = tableViewMock.tableView.tableFooterView as? UIActivityIndicatorView {
            XCTAssert(view.isAnimating)
        } else {
            XCTAssert(false)
        }
    }

    func testHideFooter() {
        tableViewMock.hideFooterLoader()
        if let view = tableViewMock.tableView.tableFooterView {
            XCTAssert(view.frame == .zero)
        } else {
            XCTAssert(true)
        }
    }

}
