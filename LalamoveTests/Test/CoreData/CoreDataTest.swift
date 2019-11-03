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

    lazy var coreData: CoreDataManager = {
        let coreData = CoreDataManager.sharedInstance
        coreData.setupTestEnvironment()
        return coreData
    }()

    override func setUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: coreData.networkManagedContext)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeleteAll() {
        let alldeliveries = coreData.fetchData(from: DeliveryCoreDataModel.self)
        let alllocations = self.coreData.fetchData(from: LocationCoreDataModel.self)

        XCTAssertEqual(alldeliveries.count, alllocations.count)

        if !alldeliveries.isEmpty {
            let notificationExpectation = expectation(description: "Deleting Deliveries")
            coreData.deleteAll(DeliveryCoreDataModel.self)
            saveNotificationCompleteHandler = { notif in
                notificationExpectation.fulfill()
                let alldeliveries = self.coreData.fetchData(from: DeliveryCoreDataModel.self)
                let alllocations = self.coreData.fetchData(from: LocationCoreDataModel.self)
                XCTAssert(alldeliveries.isEmpty)
                XCTAssert(alllocations.isEmpty)
            }
            waitForExpectations(timeout: 5)
        } else {
            coreData.deleteAll(DeliveryCoreDataModel.self)
            let alldeliveries = self.coreData.fetchData(from: DeliveryCoreDataModel.self)
            let alllocations = self.coreData.fetchData(from: LocationCoreDataModel.self)
            XCTAssert(alldeliveries.isEmpty)
            XCTAssert(alllocations.isEmpty)
        }
    }
}

extension CoreDataTest {
    func contextSaved( notification: Notification ) {
        print("contextSaved----------\(notification)")
        saveNotificationCompleteHandler?(notification)
    }
}

extension CoreDataManager {
    func setupTestEnvironment() {
        do {
            try self.persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("fix this")
        }
    }
}
