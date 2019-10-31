//
//  URLRequestBuilder.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
import Alamofire

class URLRequestBuilder: URLRequestConvertible {
    let components: URLRequestComponentsProtocol
    let sessionConfiguration: APISessionConfigurationProtocol
    
    required init(components: URLRequestComponentsProtocol, sessionConfiguration: APISessionConfigurationProtocol) {
        self.components = components
        self.sessionConfiguration = sessionConfiguration
    }
    
    func asURLRequest() throws -> URLRequest {
        let mutableURLRequest = NSMutableURLRequest()
        
        // 1. Create URL
        if let baseURL = URL(string: sessionConfiguration.baseURL),
            let requestURL = URL(string: components.path),
            let components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) {
            mutableURLRequest.url = components.url(relativeTo: baseURL)
        } else {
            mutableURLRequest.url = URL(string: sessionConfiguration.baseURL)
        }
        
        // 2. Assign HTTP Method
        mutableURLRequest.httpMethod = components.method.rawValue
        
        // 3. Add Headers
        mutableURLRequest.allHTTPHeaderFields = components.extraHeaders
        
        // 4. Add Parameters
        if let encodedRequest = try? components.encoding.encode(mutableURLRequest, with: components.parameters) {
            return encodedRequest
        } else {
            return mutableURLRequest as URLRequest
        }
    }
}
