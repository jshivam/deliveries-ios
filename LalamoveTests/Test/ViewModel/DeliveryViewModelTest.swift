//
//  DeliveryViewModelTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Lalamove

class DeliveryViewModelTest: XCTestCase {

    lazy var coreData: CoreDataManager = {
        let coreData = CoreDataManager.sharedInstance
        return coreData
    }()

    let viewModel = DeliveryListViewModel()
    var saveNotificationCompleteHandler: ((Notification) -> Void)?

    override func setUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: coreData.networkManagedContext)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfSectinos() {
        XCTAssertEqual(viewModel.numberOfSections(), 1)
    }

    func testNumberOfRows() {
        let deliveries = CoreDataManager.sharedInstance.fetchData(from: DeliveryCoreDataModel.self)
        XCTAssertEqual(viewModel.numberOfRows(section: 0), deliveries.count)
    }

//    func testDeleteAllAndResetState() {
//        let deliveries = CoreDataManager.sharedInstance.fetchData(from: DeliveryCoreDataModel.self)
//        viewModel.deleteAllDeliveries()
//        XCTAssertEqual(viewModel.currentOffSet, -1)
//        if deliveries.isEmpty {
//            let deliveries = CoreDataManager.sharedInstance.fetchData(from: DeliveryCoreDataModel.self)
//            XCTAssertEqual(0, deliveries.count)
//        } else {
//            saveNotificationCompleteHandler = { notif in
//                XCTAssertEqual(self.viewModel.numberOfRows(section: 0), 0)
//            }
//        }
//    }

    func testFetchDataWithOutCache() {
        let viewModel = DeliveryListViewModel()
        viewModel.fetchDeliveries(useCache: false) { (_) in
            self.saveNotificationCompleteHandler = { _ in
                let deliveries = CoreDataManager.sharedInstance.fetchData(from: DeliveryCoreDataModel.self)
                XCTAssertEqual(self.viewModel.numberOfRows(section: 0), deliveries.count)
            }
        }
    }

    func testFetchDataWithCache() {
        let viewModel = DeliveryListViewModel()
        viewModel.fetchDeliveries(useCache: true) { (_) in
            self.saveNotificationCompleteHandler = { _ in
                let deliveries = CoreDataManager.sharedInstance.fetchData(from: DeliveryCoreDataModel.self)
                XCTAssertEqual(self.viewModel.numberOfRows(section: 0), deliveries.count)
            }
        }
    }

    func testFetchtNextData() {
        let viewModel = DeliveryListViewModel()
        viewModel.isFetchingDeliveries = true
        XCTAssertEqual(viewModel.shallFetchNextData(indexPath: NSIndexPath.init(row: 0, section: 0) as IndexPath), false)
    }
}

extension DeliveryViewModelTest {
    func contextSaved( notification: Notification ) {
        print("contextSaved----------\(notification)")
        saveNotificationCompleteHandler?(notification)
    }
}
