//
//  URLRequestBuilderTest.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import Deliveries
@testable import Alamofire

class URLRequestBuilderTest: XCTestCase {

    var builder: URLRequestBuilder!
    var requestComponent: URLRequestComponentsMock!
    var sessionconfig: APISessionConfigurationMock!

    override func setUp() {
        requestComponent = URLRequestComponentsMock()
        sessionconfig = APISessionConfigurationMock()
        builder = URLRequestBuilder.init(components: requestComponent, sessionConfiguration: sessionconfig)
    }

    func testEmptyBaseURL() {
        sessionconfig.baseURL = ""
        requestComponent.parameters = ["key": "val"]
        let req = try? builder.asURLRequest()
        let requestURL = req?.url?.absoluteString
        XCTAssertNil(requestURL)
    }

    func testBaseURLAndPathURL() {
        sessionconfig.baseURL = "https://www.google.co.in/"
        requestComponent.path = "https://github.com/jshivam/deliveries-ios"
        let req = try? builder.asURLRequest()
        let absoluteString = req?.url?.absoluteString
        XCTAssertEqual(absoluteString, requestComponent.path)
    }

    func testConfigs() {
        requestComponent.extraHeaders = ["key": "value"]
        requestComponent.method = .post

        let req = try? builder.asURLRequest()
        XCTAssertEqual(requestComponent.extraHeaders, req?.allHTTPHeaderFields)
        XCTAssertEqual(requestComponent.method.rawValue, req?.httpMethod)
    }

    override func tearDown() {
        requestComponent = nil
        sessionconfig = nil
        builder = nil
    }
}
