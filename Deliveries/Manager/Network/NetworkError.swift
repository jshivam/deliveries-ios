//
//  NetworkError.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case apiError
    case noData
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .apiError:
            return LocalizedConstants.apiError
        case .noData:
            return LocalizedConstants.noData
        case .noInternet:
            return LocalizedConstants.noInternet
        }
    }
}
