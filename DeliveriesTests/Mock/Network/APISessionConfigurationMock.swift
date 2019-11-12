//
//  APISessionConfigurationMock.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
@testable import Deliveries

class APISessionConfigurationMock: APISessionConfigurationProtocol {
    var baseURL: String = "https://mock-api-mobile.dev.lalamove.com"
}
