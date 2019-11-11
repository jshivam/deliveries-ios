//
//  DeliveryDetailViewModelTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries

class DeliveryDetailViewModelTest: XCTestCase {

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

    var viewModel: DeliveryDetailViewModel!

    override func setUp() {
        viewModel = DeliveryDetailViewModel.init(delivery: dataModel)
    }

    override func tearDown() {
        viewModel = nil
        coreData = nil
        dataModel = nil
    }

    func testDeliveryModel() {
        let isEqual = (viewModel.delivery.identifier == 100) && (viewModel.delivery.desc == "this is test") && (viewModel.delivery.imageUrl!.isEmpty)
        XCTAssert(isEqual)
    }

    func testLocationAddress() {
        let location = viewModel.delivery.location!
        XCTAssertEqual(location.address, "london")
    }

    func testLocationLatnLng() {
        let location = viewModel.delivery.location!
        let isEqual = (10 == location.lat) && (20 == viewModel.delivery.location!.lng)
        XCTAssert(isEqual)
    }
}
