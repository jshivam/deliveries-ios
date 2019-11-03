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

    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPIPerformerSuccess() {
        let requestComponent = URLRequestComponentsMock()
        let request = URLRequestBuilder.init(components: requestComponent, sessionConfiguration: APISessionConfigurationMock())
        APIPerformer().perform(request: request) { (_, result: Result<[Delivery]>) in
            switch result {
            case .success(let items):
                XCTAssertNil(items)
            case .failure:
                break
            }
        }
    }

    func testAPIPerformerError() {
        let requestComponent = URLRequestComponentsMock()
        requestComponent.method = .post
        let request = URLRequestBuilder.init(components: requestComponent, sessionConfiguration: APISessionConfigurationMock())
        APIPerformer().perform(request: request) { (_, result: Result<[Delivery]>) in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
        }
    }
}
