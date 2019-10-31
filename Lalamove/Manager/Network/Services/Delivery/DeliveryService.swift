//
//  DeliveryService.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

protocol DeliveryServiceProtocol {
    func fetchDeliveries(completion: @escaping ([Delivery]?, Error?) -> Void)
}

class DeliveryService: BaseService, DeliveryServiceProtocol {
    
    func fetchDeliveries(completion: @escaping ([Delivery]?, Error?) -> Void) {
        // 1. Create Request Component
        let requestComponent: DeliveryRequestComponent = DeliveryRequestComponent.fetch(offset: 0, limit: 10)
        
        // 2. Create a request object
        let request = URLRequestBuilder(components: requestComponent, sessionConfiguration: sessionConfiguration)
        
        // 3. Perform the request using APIPerformerProtocol
        apiPerformer.perform(request: request) { (_, response: [Delivery]?, error) in
            completion(response, error)
        }
    }
}
