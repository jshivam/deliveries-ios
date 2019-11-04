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
            return "apiError".localized()
        case .noData:
            return "noData".localized()
        case .noInternet:
            return "noInternet".localized()
        }
    }
}
