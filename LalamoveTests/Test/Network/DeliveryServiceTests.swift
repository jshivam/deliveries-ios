//
//  DeliveryServiceTests.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 02/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Lalamove
@testable import Alamofire

class DeliveryServiceTests: XCTestCase {
    var apiPerformer: APIPerformer!
    var session: SessionManagerMock!
    var deliveryService: DeliveryService!
    var sessionConfiguration: APISessionConfigurationMock!

    override func setUp() {
        session = SessionManagerMock()
        apiPerformer = APIPerformer.init(manager: session)
        sessionConfiguration = APISessionConfigurationMock()
    }

    override func tearDown() {
        apiPerformer = nil
        session = nil
        sessionConfiguration = nil
    }

    func testNetworkfailure() {
        let expctation = expectation(description: "testNetworkfailure")
        session.dataRequest.nextResultType = .apiError
        deliveryService = DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: sessionConfiguration)
        deliveryService.fetchDeliveries(offSet: 0, limit: 20) { (result) in
            expctation.fulfill()
            switch result {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
        }
        waitForExpectations(timeout: 5)
    }

    func testEmptyDeliveriesError() {
        let expctation = expectation(description: "testNetworkfailure")
        let data = JSONLoader.jsonFileToData(jsonName: "emptyDeliveries")
        session.dataRequest.nextResultType = .success(data)
        deliveryService = DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: sessionConfiguration)
        deliveryService.fetchDeliveries(offSet: 0, limit: 20) { (result) in
            expctation.fulfill()
            switch result {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
        }
        waitForExpectations(timeout: 5)
    }

    func testParsingErrorDueToInvalidJson() {
        let expctation = expectation(description: "testNetworkfailure")
        let data = JSONLoader.jsonFileToData(jsonName: "invaildDeliveries")
        session.dataRequest.nextResultType = .success(data)
        deliveryService = DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: sessionConfiguration)
        deliveryService.fetchDeliveries(offSet: 0, limit: 20) { (result) in
            expctation.fulfill()
            switch result {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
        }
        waitForExpectations(timeout: 5)
    }

    func testSuccess() {
        let expctation = expectation(description: "testNetworkfailure")
        let data = JSONLoader.jsonFileToData(jsonName: "deliveries")
        session.dataRequest.nextResultType = .success(data)
        deliveryService = DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: sessionConfiguration)
        deliveryService.fetchDeliveries(offSet: 0, limit: 20) { (result) in
            expctation.fulfill()
            switch result {
            case .success:
               XCTAssert(true)
            case .failure:
               XCTAssert(false)
           }
        }
        waitForExpectations(timeout: 5)
    }

    func testBaseUrl() {
        XCTAssertEqual(sessionConfiguration.baseURL, "https://mock-api-mobile.dev.lalamove.com")
    }
}
