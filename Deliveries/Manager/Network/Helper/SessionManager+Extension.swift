//
//  SessionManager+Extension.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Alamofire

extension SessionManager: SessionProtocol {
    func request(_ urlRequest: URLRequestConvertible) -> DataRequestProtocol {
        return self.request(urlRequest) as DataRequest
    }
}

protocol SessionProtocol {
    func request(_ urlRequest: URLRequestConvertible) -> DataRequestProtocol
}

protocol DataRequestProtocol {
    @discardableResult
    func responseJSON(completionHandler: @escaping (DataResponse<Any>) -> Void) -> DataRequestProtocol
    func log() -> Self
    func validate() -> Self
}

extension DataRequest: DataRequestProtocol {
    func responseJSON(completionHandler: @escaping (DataResponse<Any>) -> Void) -> DataRequestProtocol {
        return self.responseJSON(completionHandler: completionHandler) as DataRequest
    }
}
