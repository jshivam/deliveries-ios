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
    var data: Data?
    var faliure: Result<[T]>?
    private var success: Result<[T]>? {

        guard let data = data else { return nil }

        do {
            let responseData = try JSONDecoder().decode([T].self, from: data)
            return Result<[T]>.success(responseData)
        } catch {
            print(error)
            self.faliure = .failure(error)
        }
        return nil
    }

    func perform<T: Codable>(request: URLRequestConvertible, completionHandler: @escaping (_ request: URLRequest?, _ result: Result<T>) -> Void) {

        if success != nil {
            completionHandler(urlRequest, success as! Result<T>) // swiftlint:disable:this force_cast
        }

        if faliure != nil {
            completionHandler(urlRequest, faliure as! Result<T>) // swiftlint:disable:this force_cast
        }
    }
}
