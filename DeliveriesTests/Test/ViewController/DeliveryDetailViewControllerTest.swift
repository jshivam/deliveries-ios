//
//  DeliveryDetailViewControllerTest.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries

class DeliveryDetailViewControllerTest: XCTestCase {

    var detailViewController: DeliveryDetailViewController!
    var coreData: CoreDataManager! = CoreDataManager.init(config: CoreDataMockConfig())
    lazy var dataModel: DeliveryCoreDataModel! = {
        let location = Location.init(lat: 10, lng: 20, address: "london")
        let delivery = Delivery.init(identifier: 100, desc: "this is test", imageUrl: "https://www.google.co.in/", location: location)
        let deliveryModel = DeliveryCoreDataModel.create(coreData: coreData, delivery: delivery)
        return deliveryModel
    }()

    override func setUp() {
        let viewModel = DeliveryDetailViewModel.init(delivery: dataModel)
        detailViewController = DeliveryDetailViewController.init(viewModel: viewModel)
        detailViewController.view.tag = 0
    }

    override func tearDown() {
        detailViewController = nil
        coreData = nil
        dataModel = nil
    }

    func testMarker() {
        for annotation in self.detailViewController.mapView.annotations where annotation.title == "london" {
            XCTAssertNotNil(detailViewController.mapView(detailViewController.mapView, viewFor: annotation))
            return
        }
        XCTFail("Fail")
    }
}
