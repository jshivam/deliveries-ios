//
//  DeliveryDetailViewModelTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Lalamove

class DeliveryDetailViewModelTest: XCTestCase {

    var viewModel: DeliveryDetailViewModel!

    override func setUp() {
        let dataModel = DeliveryCoreDataModel.create()
        let location = Location.init(lat: 0, lng: 0, address: "london")
        let delivery = Delivery.init(identifier: 0, desc: "this is test", imageUrl: "", location: location)
        dataModel.update(delivery: delivery, offSet: 0)
        viewModel = DeliveryDetailViewModel.init(delivery: dataModel)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        XCTAssertNotNil(viewModel.delivery.location?.address)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
