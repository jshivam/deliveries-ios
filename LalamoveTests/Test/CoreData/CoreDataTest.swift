//
//  CoreDataTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
import CoreData
@testable import Lalamove

class CoreDataTest: XCTestCase {

    var saveNotificationCompleteHandler: ((Notification) -> Void)?
    let coreData = CoreDataManager.init(config: CoreDataMockConfig())

    override func setUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: coreData.networkManagedContext)
    }

    override func tearDown() {
        saveNotificationCompleteHandler =  nil
    }

    func testCreateModel() {
        let model = coreData.createObject(DeliveryCoreDataModel.self)
        XCTAssertNotNil(model)
    }

    func testFetchModel() {
        let alldeliveries = self.coreData.fetchData(from: DeliveryCoreDataModel.self, moc: self.coreData.workerManagedContext)
        XCTAssertNotNil(alldeliveries)
    }

    func testDelete() {

        coreData.createObject(DeliveryCoreDataModel.self)
        coreData.deleteAll(DeliveryCoreDataModel.self)
        let notificationExpectation = expectation(description: "Deleting Deliveries")

        saveNotificationCompleteHandler = { [weak self] (notification) in
            guard let `self` = self else { return }
            notificationExpectation.fulfill()
            let alldeliveries = self.coreData.fetchData(from: DeliveryCoreDataModel.self, moc: self.coreData.workerManagedContext)
            let alllocations = self.coreData.fetchData(from: LocationCoreDataModel.self, moc: self.coreData.workerManagedContext)
            let isAllDeleted = (alldeliveries.count == alllocations.count) && alldeliveries.isEmpty
            XCTAssert(isAllDeleted)
        }

        waitForExpectations(timeout: 5)
    }
}

extension CoreDataTest {
    func contextSaved( notification: Notification ) {
        print("contextSaved----------\(notification)")
        saveNotificationCompleteHandler?(notification)
    }
}
