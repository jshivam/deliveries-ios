//
//  NetworkError.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 02/11/19.
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
            return NSLocalizedString("Oops! Something went wrong!", comment: "")
        case .noData:
            return NSLocalizedString("We don't have any data to show now!", comment: "")
        case .noInternet:
            return NSLocalizedString("The Internet connection appears to be offline", comment: "")
        }
    }
}
