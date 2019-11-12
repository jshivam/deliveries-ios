//
//  APIPerformer.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Alamofire

protocol APIPerformerProtocol {
    func perform<T: Codable>(request: URLRequestConvertible, completionHandler: @escaping (_ request: URLRequest?, _ result: Result<T>) -> Void)
}

class APIPerformer {
    private let sessionManager: SessionProtocol
    init(manager: SessionProtocol = SessionManager.default) {
        self.sessionManager = manager
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
