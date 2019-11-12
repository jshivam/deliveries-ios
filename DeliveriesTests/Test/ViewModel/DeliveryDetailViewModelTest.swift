//
//  DeliveryDetailViewModelTest.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries

class DeliveryDetailViewModelTest: XCTestCase {

    var coreData: CoreDataManager! = CoreDataManager.init(config: CoreDataMockConfig())

    lazy var dataModel: DeliveryCoreDataModel! = {
        let location = Location.init(lat: 10, lng: 20, address: "london")
        let delivery = Delivery.init(identifier: 100, desc: "this is test", imageUrl: "https://www.google.co.in/", location: location)
        let deliveryModel = DeliveryCoreDataModel.create(coreData: coreData, delivery: delivery)
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

    func testDeliveryDescribtion() {
        let expectedDescribtion = "this is test at london"
        XCTAssertEqual(viewModel.deliveryDescribtion, expectedDescribtion)
    }

    func testimageURL() {
        let expectedURL = "https://www.google.co.in/"
        XCTAssertEqual(viewModel.imageURL, expectedURL)
    }

    func testCoordinate2D() {
        XCTAssertNotNil(viewModel.coordinate2D)
    }

    func testAnnotaton() {
        XCTAssertNotNil(viewModel.annotation)
    }
}
