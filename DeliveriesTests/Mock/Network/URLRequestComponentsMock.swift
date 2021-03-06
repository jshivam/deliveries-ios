//
//  URLRequestComponentsMock.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
@testable import Deliveries
@testable import Alamofire

class URLRequestComponentsMock: URLRequestComponentsProtocol {
    var method: HTTPMethod = .get
    var encoding: ParameterEncoding = URLEncoding.default
    var path: String = Endpoint.deliveries.rawValue
    var parameters: [String: Any]?
    var extraHeaders: [String: String]?
}
