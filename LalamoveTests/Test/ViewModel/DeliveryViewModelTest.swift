//
//  DeliveryViewModelTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
import CoreData
@testable import Lalamove

class DeliveryViewModelTest: XCTestCase {

    let coreData = CoreDataManager.init(config: CoreDataMockConfig())
    var viewModel: DeliveryListViewModel!
    var saveNotificationCompleteHandler: ((Notification) -> Void)?

    var apiPerformer: APIPerformer!
    var session: SessionManagerMock!
    var deliveryService: DeliveryService!

    override func setUp() {

        session = SessionManagerMock()
        apiPerformer = APIPerformer(manager: session)

        viewModel = DeliveryListViewModel()
        viewModel.coreData = coreData

        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: coreData.networkManagedContext)
    }

    override func tearDown() {
        apiPerformer = nil
        session = nil
        viewModel = nil
        saveNotificationCompleteHandler = nil
    }

    func testNumberOfSectinos() {
        XCTAssertEqual(viewModel.numberOfSections(), 1)
    }

    func testNumberOfRows() {
        let deliveries = coreData.fetchData(from: DeliveryCoreDataModel.self)
        XCTAssertEqual(viewModel.numberOfRows(section: 0), deliveries.count)
    }

    func testFetchDataFromNetworkSuccess() {
        let data = JSONLoader.jsonFileToData(jsonName: "deliveries")
        session.dataRequest.nextResultType = .success(data)
        deliveryService = DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: APISessionConfigurationMock())
        viewModel.deliveryServices = deliveryService

        let fetchExpectation = expectation(description: "fetchExpectation")
        viewModel.fetchDeliveries(useCache: false) { (status) in
            fetchExpectation.fulfill()
            switch status {
            case .fromServer:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testFetchDataFromNetworkFailure() {
        session.dataRequest.nextResultType = .apiError
        deliveryService = DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: APISessionConfigurationMock())
        viewModel.deliveryServices = deliveryService

        let fetchExpectation = expectation(description: "fetchExpectation")
        viewModel.fetchDeliveries(useCache: false) { (status) in
            fetchExpectation.fulfill()
            switch status {
            case .faliure:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testFetchDataFromCacheWhenAvaiable() {

        let fetchExpectation = expectation(description: "fetchExpectation")
        saveNotificationCompleteHandler = { [weak self] (notification) in
            guard let `self` = self else { return }
            self.viewModel.fetchDeliveries(useCache: true) { (status) in
                fetchExpectation.fulfill()
                switch status {
                case .fromCache:
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
        }
        let model = coreData.createObject(DeliveryCoreDataModel.self)
        model.identifier = 1
        model.offSet = 0
        model.desc = "dummy2"
        model.location = coreData.createObject(LocationCoreDataModel.self)
        coreData.saveContext()
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testFetchNextData() {
        let rows = viewModel.numberOfRows(section: 0)
        viewModel.lastVisibileIndexPath = IndexPath.init(row: rows - 1, section: 0)

        let data = JSONLoader.jsonFileToData(jsonName: "deliveries")
        session.dataRequest.nextResultType = .success(data)
        deliveryService = DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: APISessionConfigurationMock())
        viewModel.deliveryServices = deliveryService

        let fetchExpectation = expectation(description: "fetchExpectation")
        self.viewModel.fetchDeliveries(useCache: true) { (status) in
            fetchExpectation.fulfill()
            switch status {
            case .fromServer:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testFetchNextDataCalled() {

        viewModel.fetchNextDataHandler = { (_) in
            XCTAssert(true)
        }

        let rows = viewModel.numberOfRows(section: 0)
        viewModel.lastVisibileIndexPath = IndexPath.init(row: rows - 1, section: 0)
    }
}

extension DeliveryViewModelTest {
    func contextSaved( notification: Notification ) {
        saveNotificationCompleteHandler?(notification)
    }
}
