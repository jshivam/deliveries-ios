//
//  BaseService.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Alamofire

class BaseService {
    let apiPerformer: APIPerformerProtocol
    let sessionConfiguration: APISessionConfigurationProtocol

    required init(apiPerformer: APIPerformerProtocol = APIPerformer(),
                  sessionConfiguration: APISessionConfigurationProtocol = APISessionConfiguration()) {
        self.apiPerformer = apiPerformer
        self.sessionConfiguration = sessionConfiguration
    }
}
