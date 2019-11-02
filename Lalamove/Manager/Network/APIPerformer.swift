//
//  APIPerformer.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
import Alamofire

protocol APIPerformerProtocol {
    func perform<T: Codable>(request: URLRequestConvertible, completionHandler: @escaping (_ request: URLRequest?, _ result: Result<T>) -> Void)
}

class APIPerformer {
    fileprivate var sessionManager: SessionManager!
    init() {
        initSessionManager()
    }

    func initSessionManager() {
        let configuration = URLSessionConfiguration.default
        sessionManager = SessionManager(configuration: configuration)
    }
}

extension APIPerformer: APIPerformerProtocol {

    func perform<T: Codable>(request: URLRequestConvertible, completionHandler: @escaping (_ request: URLRequest?, _ result: Result<T>) -> Void) {
        sessionManager.request(request).log().validate().responseJSON { (response) in
            let request = response.request
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let responseData = try JSONDecoder().decode(T.self, from: data)
                        print(responseData)
                        completionHandler(request, .success(responseData))
                    } catch {
                        completionHandler(request, .failure(NetworkError.apiError))
                    }
                }
            case .failure(let error):
                if let err = error as? URLError, err.code == .notConnectedToInternet {
                    completionHandler(request, .failure(NetworkError.noInternet))
                } else {
                    completionHandler(request, .failure(NetworkError.apiError))
                }
            }
        }
    }
}
