//
//  DeliveryRequestComponent.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
import Alamofire

enum DeliveryRequestComponent: URLRequestComponentsProtocol {

    case fetch(offset: Int, limit: Int)

    var method: HTTPMethod {
        switch self {
        case .fetch:
            return .get
        }
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }

    var path: String {
        switch self {
        case .fetch:
            return Endpoint.deliveries.rawValue
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .fetch(let offset, let limit):
            return ["offset": offset, "limit": limit]
        }
    }

    var extraHeaders: [String: String]? {
        return nil
    }
}
