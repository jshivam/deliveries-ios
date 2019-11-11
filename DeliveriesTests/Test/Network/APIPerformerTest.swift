//
//  APIPerformerTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries
@testable import Alamofire

class APIPerformerTest: XCTestCase {

    var apiPerformer: APIPerformer!
    var session: SessionManagerMock!

    var request: URLRequestBuilder {
        let requestComponent = URLRequestComponentsMock()
        let request = URLRequestBuilder.init(components: requestComponent, sessionConfiguration: APISessionConfigurationMock())
        return request
    }

    override func setUp() {
        session = SessionManagerMock()
        apiPerformer = APIPerformer.init(manager: session)
    }

    override func tearDown() {
        apiPerformer = nil
        session = nil
    }

    func testAPIError() {

        let expctation = expectation(description: "testAPIError")
        session.dataRequest.nextResultType = .apiError
        apiPerformer.perform(request: request) { (_, result: Result<MockModel>) in
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

    func testNoInternetError() {
        let expctation = expectation(description: "testNoInternetError")
        session.dataRequest.nextResultType = .noInternetError
        apiPerformer.perform(request: request) { (_, result: Result<MockModel>) in
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

    func testApiSuccess() {
        let expctation = expectation(description: "testApiSuccess")
        let data = MockModel.data
        session.dataRequest.nextResultType = .success(data)
        apiPerformer.perform(request: request) { (_, result: Result<MockModel>) in
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

    func testParsingError() {
        let expctation = expectation(description: "testParsingError")
        session.dataRequest.nextResultType = .parsingError
        apiPerformer.perform(request: request) { (_, result: Result<MockModel>) in
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
}
