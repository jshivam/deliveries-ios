//
//  APIPerformerProtocolMock.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 02/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
@testable import Alamofire
@testable import Lalamove

class APIPerformerProtocolMock<T: Codable>: APIPerformerProtocol {

    var urlRequest: URLRequest!
    var data: Data!
    var faliure: Result<[T]>!
    private var success: Result<T> {
        let responseData = try? JSONDecoder().decode(T.self, from: self.data)
        return Result<T>.success(responseData!)
    }

    func perform<T: Codable>(request: URLRequestConvertible, completionHandler: @escaping (_ request: URLRequest?, _ result: Result<T>) -> Void) {

        if faliure != nil {
            completionHandler(urlRequest, faliure as! Result<T>) // swiftlint:disable:this force_cast
        } else {
            completionHandler(urlRequest, success as! Result<T>) // swiftlint:disable:this force_cast
        }
    }
}
