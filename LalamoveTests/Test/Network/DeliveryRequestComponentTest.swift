//
//  DeliveryRequestComponentTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 06/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Lalamove
@testable import Alamofire

class DeliveryRequestComponentTest: XCTestCase {

    var deliveryRequestComponent: DeliveryRequestComponent!
    override func setUp() {
        deliveryRequestComponent = DeliveryRequestComponent.fetch(offset: 10, limit: 100)
    }

    override func tearDown() {
        deliveryRequestComponent = nil
    }

    func testComponents() {
        XCTAssertEqual(deliveryRequestComponent.method, HTTPMethod.get)
        XCTAssertEqual(deliveryRequestComponent.path, Endpoint.deliveries.rawValue)
        let offSet = deliveryRequestComponent.parameters?["offset"] as? Int
        let limit = deliveryRequestComponent.parameters?["limit"] as? Int
        XCTAssertEqual(offSet, 10)
        XCTAssertEqual(limit, 100)
        XCTAssertNil(deliveryRequestComponent.extraHeaders)
    }
}
