//
//  CoreDataTest.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
import CoreData
@testable import Deliveries

class CoreDataTest: XCTestCase {

    var coreData: CoreDataManager!

    override func setUp() {
        coreData = CoreDataManager.init(config: CoreDataMockConfig())
    }

    override func tearDown() {
        coreData = nil
    }

    func testCreateModel() {
        let location = Location.init(lat: -39, lng: 23, address: "Delhi")
        let delivery = Delivery.init(identifier: 101,
                                     desc: "ABC",
                                     imageUrl: "https://www.hackingwithswift.com/100/swiftui",
                                     location: location)

        DeliveryCoreDataModel.create(coreData: coreData, delivery: delivery)
        coreData.saveContext()
        let predicate = NSPredicate(format: "identifier == 101")
        let fetchedModels = coreData.fetchData(from: DeliveryCoreDataModel.self, predicate: predicate, moc: coreData.workerManagedContext)
        XCTAssertEqual(fetchedModels.first?.identifier, 101)
    }

    func testFetchModel() {
        let location = Location.init(lat: -139, lng: 123, address: "Bombay")
        let delivery = Delivery.init(identifier: 103,
                                     desc: "PQR",
                                     imageUrl: "https://www.hackingwithswift.com/100/swiftui",
                                     location: location)

        DeliveryCoreDataModel.create(coreData: coreData, delivery: delivery)
        coreData.saveContext()
        let predicate = NSPredicate(format: "identifier == 103")
        let fetchedModels = coreData.fetchData(from: DeliveryCoreDataModel.self, predicate: predicate, moc: coreData.workerManagedContext)
        XCTAssertEqual(fetchedModels.count, 1)
        XCTAssertNotNil(fetchedModels.first)
        XCTAssertEqual(fetchedModels.first?.identifier, 103)
    }

    func testDelete() {

        let location = Location.init(lat: -9, lng: 3, address: "GGN")
        let delivery = Delivery.init(identifier: 102,
                                     desc: "XYX",
                                     imageUrl: "https://www.hackingwithswift.com/100/swiftui",
                                     location: location)

        DeliveryCoreDataModel.create(coreData: coreData, delivery: delivery)
        coreData.deleteAll(DeliveryCoreDataModel.self)
        coreData.saveContext()

        // LocationCoreDataModel should be deleted autimatically because of cascade delete rule
        let alldeliveries = coreData.fetchData(from: DeliveryCoreDataModel.self, moc: coreData.workerManagedContext)
        let alllocations = coreData.fetchData(from: LocationCoreDataModel.self, moc: coreData.workerManagedContext)
        let isAllDeleted = (alldeliveries.count == alllocations.count) && alldeliveries.isEmpty
        XCTAssert(isAllDeleted)
    }
}
