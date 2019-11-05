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
    var apiPerfomer: APIPerformerProtocolMock<Delivery> = APIPerformerProtocolMock()
    var sessionConfiguration: APISessionConfigurationProtocol = APISessionConfiguration()
    var deliveryService: DeliveryServiceProtocol!

    override func setUp() {
        super.setUp()
    }

//    func testAPIfailure() {
//        deliveryService = DeliveryService(apiPerformer: apiPerfomer, sessionConfiguration: sessionConfiguration)
//        apiPerfomer.data = nil
//        apiPerfomer.faliure = Result<[Delivery]>.failure(NetworkError.apiError)
//        deliveryService.fetchDeliveries(offSet: 0, limit: 20) { (result) in
//            switch result {
//            case .success:
//                XCTAssert(false)
//            case .failure:
//                XCTAssert(true)
//            }
//        }
//    }
//
//    func testMockJson() {
//        deliveryService = DeliveryService(apiPerformer: apiPerfomer, sessionConfiguration: sessionConfiguration)
//        apiPerfomer.data = JSONLoader.jsonFileToData(jsonName: "deliveries")
//        apiPerfomer.faliure = nil
//        deliveryService.fetchDeliveries(offSet: 0, limit: 20) { (result) in
//            switch result {
//            case .success:
//                XCTAssert(true)
//            case .failure:
//                XCTAssert(false)
//            }
//        }
//    }
//
//    func testTimeOutData() {
//        let fetchDeliveryExpectation = expectation(description: "Fetching Deliveries")
//        deliveryService = DeliveryService()
//        deliveryService.fetchDeliveries(offSet: 0, limit: Constants.deliveryLimitPerRequest) { (_) in
//            fetchDeliveryExpectation.fulfill()
//        }
//        waitForExpectations(timeout: 10)
//    }
//
//    func testBaseUrl() {
//        XCTAssertEqual(sessionConfiguration.baseURL, "https://mock-api-mobile.dev.lalamove.com")
//    }
}
