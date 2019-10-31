//
//  URLRequestComponents.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
import Alamofire

protocol URLRequestComponentsProtocol {
    var method: Alamofire.HTTPMethod { get }
    var encoding: Alamofire.ParameterEncoding { get }
    
    var path: String { get }
    var parameters: [String: Any]? { get }
    var extraHeaders: [String: String]? { get }
}

extension URLRequestComponentsProtocol {
    
}

