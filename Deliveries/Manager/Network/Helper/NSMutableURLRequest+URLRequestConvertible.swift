//
//  NSMutableURLRequest+URLRequestConvertible.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
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
