//
//  NSMutableURLRequest+URLRequestConvertible.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Alamofire

extension NSMutableURLRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return self as URLRequest
    }
}

extension Request {
    func log() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}
