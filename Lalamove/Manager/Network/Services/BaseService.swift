//
//  BaseService.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Alamofire

class BaseService {
    let apiPerformer: APIPerformerProtocol
    let sessionConfiguration: APISessionConfigurationProtocol
    
    required init(apiPerformer: APIPerformerProtocol, sessionConfiguration: APISessionConfigurationProtocol) {
        self.apiPerformer = apiPerformer
        self.sessionConfiguration = sessionConfiguration
    }
    
    func createRequest<T: URLRequestComponentsProtocol>(forRequest request: T) -> URLRequestConvertible {
        return URLRequestBuilder(components: request, sessionConfiguration: sessionConfiguration)
    }
}
