//
//  DeliveryViewModelTest.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//u

import XCTest
import CoreData
@testable import Deliveries

class DeliveryViewModelTest: XCTestCase {

    var coreData: CoreDataManager! = CoreDataManager.init(config: CoreDataMockConfig())
    var viewModel: DeliveryListViewModel!

    var apiPerformer: APIPerformer!
    var session: SessionManagerMock!
    var deliveryService: DeliveryService!
    var configMock: APISessionConfigurationMock!

    override func setUp() {

        session = SessionManagerMock()
        apiPerformer = APIPerformer(manager: session)
        configMock = APISessionConfigurationMock()
        deliveryService = DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: configMock)
        viewModel = DeliveryListViewModel.init(deliveryServices: deliveryService, coreData: coreData)
    }

    override func tearDown() {
        configMock = nil
        deliveryService = nil
        coreData = nil
        apiPerformer = nil
        session = nil
        viewModel = nil
    }

    func testNumberOfSectinos() {
        XCTAssertEqual(viewModel.numberOfSections(), 1)
    }

    func testNumberOfRows() {
        XCTAssertEqual(viewModel.numberOfRows(section: 0), viewModel.fetchedObjectsCount())
    }

    func testFetchDataFromNetworkSuccess() {
        let data = JSONLoader.jsonFileToData(jsonName: "deliveries")
        session.dataRequest.nextResultType = .success(data)

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
        let model = coreData.createObject(DeliveryCoreDataModel.self)
        model.identifier = 11
        model.offSet = 0
        model.desc = "dummy22"
        model.location = coreData.createObject(LocationCoreDataModel.self)
        coreData.saveContext()

        let fetchExpectation = expectation(description: "fetchExpectation")
        self.viewModel.fetchDeliveries(useCache: true) { (status) in
            fetchExpectation.fulfill()
            switch status {
            case .fromCache:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testFetchNextData() {
        let rows = viewModel.numberOfRows(section: 0)
        viewModel.lastVisibileIndexPath = IndexPath.init(row: rows - 1, section: 0)

        let data = JSONLoader.jsonFileToData(jsonName: "deliveries")
        session.dataRequest.nextResultType = .success(data)

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
