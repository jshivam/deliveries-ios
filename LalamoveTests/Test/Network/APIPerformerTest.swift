//
//  APIPerformerTest.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 03/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Lalamove
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
        session.dataRequest.nextResultType = .apiError
        apiPerformer.perform(request: request) { (_, result: Result<MockModel>) in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
        }
    }

    func testNoInternetError() {
        session.dataRequest.nextResultType = .noInternetError
        apiPerformer.perform(request: request) { (_, result: Result<MockModel>) in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
        }
    }

    func testApiSuccess() {
        session.dataRequest.nextResultType = .success
        apiPerformer.perform(request: request) { (_, result: Result<MockModel>) in
            switch result {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTAssert(false)
            }
        }
    }

    func testParsingError() {
        session.dataRequest.nextResultType = .parsingError
        apiPerformer.perform(request: request) { (_, result: Result<MockModel>) in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
        }
    }
}
