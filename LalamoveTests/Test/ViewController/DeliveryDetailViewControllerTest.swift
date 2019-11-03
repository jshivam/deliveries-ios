//
//  DeliveryDetailViewControllerTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Lalamove

class DeliveryDetailViewControllerTest: XCTestCase {

    var detailViewController: DeliveryDetailViewController!

    override func setUp() {
        let dataModel = DeliveryCoreDataModel.create()
        let location = Location.init(lat: 0, lng: 0, address: "london")
        let delivery = Delivery.init(identifier: 0, desc: "this is test", imageUrl: "", location: location)
        dataModel.update(delivery: delivery, offSet: 0)
        let viewModel = DeliveryDetailViewModel.init(delivery: dataModel)
        detailViewController = DeliveryDetailViewController.init(viewModel: viewModel)
        detailViewController.view.tag = 0
    }

    override func tearDown() {

    }

    func testViewModelLinkage() {
        XCTAssertEqual(detailViewController.viewModel.delivery.location!.address, "london")
    }

    func testMarker() {

        for annotation in self.detailViewController.mapView.annotations where annotation.title == self.detailViewController.viewModel.delivery.location!.address {
            XCTAssert(true)
            XCTAssertNotNil(detailViewController.mapView(detailViewController.mapView, viewFor: annotation))
            return
        }
        XCTFail("Fail")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
