//
//  SessionManagerMock.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
@testable import Alamofire
@testable import Deliveries

enum NextResultType {
    case noInternetError
    case apiError
    case parsingError
    case success(Data?)

    var nextResult: Result<Any> {
        switch self {
        case .apiError:
            return Result<Any>.failure(NetworkError.apiError)
        case .noInternetError:
            let error = URLError.init(.notConnectedToInternet)
            return Result<Any>.failure(error)
        case .success, .parsingError:
            return Result<Any>.success([])
        }
    }

    var data: Data? {
        switch self {
        case .success(let data):
            return data
        case .parsingError:
            return Data.init([0, 1, 0])
        default:
            return nil
        }
    }
}

class SessionManagerMock: SessionProtocol {

    var dataRequest = DataRequestMock()

    func request(_ urlRequest: URLRequestConvertible) -> DataRequestProtocol {
        return dataRequest
    }
}

class DataRequestMock: DataRequestProtocol {

    var nextResultType: NextResultType!

    private var nextData: DataResponse<Any> {
        return DataResponse<Any>.init(request: nil, response: nil, data: nextResultType.data, result: nextResultType.nextResult)
    }

    func responseJSON(completionHandler: @escaping (DataResponse<Any>) -> Void) -> DataRequestProtocol {
        completionHandler(nextData)
        return self
    }

    func log() -> Self {
        return self
    }

    func validate() -> Self {
        return self
    }
}
