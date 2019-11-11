//
//  DeliveryDetailViewControllerTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries

class DeliveryDetailViewControllerTest: XCTestCase {

    var detailViewController: DeliveryDetailViewController!
    var coreData: CoreDataManager! = CoreDataManager.init(config: CoreDataMockConfig())
    lazy var dataModel: DeliveryCoreDataModel! = {
        let deliveryModel = coreData.createObject(DeliveryCoreDataModel.self)
        let locationModel = coreData.createObject(LocationCoreDataModel.self)
        deliveryModel.location = locationModel
        let location = Location.init(lat: 10, lng: 20, address: "london")
        let delivery = Delivery.init(identifier: 100, desc: "this is test", imageUrl: "", location: location)
        deliveryModel.update(delivery: delivery, offSet: 0)
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

    func testViewModelLinkage() {
        XCTAssertEqual(detailViewController.viewModel.delivery.location!.address, "london")
    }

    func testMarker() {
        for annotation in self.detailViewController.mapView.annotations where annotation.title == self.detailViewController.viewModel.delivery.location!.address {
            XCTAssertNotNil(detailViewController.mapView(detailViewController.mapView, viewFor: annotation))
            return
        }
        XCTFail("Fail")
    }
}
