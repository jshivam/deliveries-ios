//
//  DeliveryService.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Alamofire

protocol DeliveryServiceProtocol {
    func fetchDeliveries(offSet: Int, limit: Int, completion: @escaping (Result<[Delivery]>) -> Void)
}

class DeliveryService: BaseService, DeliveryServiceProtocol {

    func fetchDeliveries(offSet: Int, limit: Int, completion: @escaping (Result<[Delivery]>) -> Void) {
        // 1. Create Request Component
        let requestComponent: DeliveryRequestComponent = DeliveryRequestComponent.fetch(offset: offSet, limit: limit)

        // 2. Create a request object
        let request = URLRequestBuilder(components: requestComponent, sessionConfiguration: sessionConfiguration)

        // 3. Perform the request using APIPerformerProtocol
        apiPerformer.perform(request: request) { (_, result: Result<[Delivery]>) in
            debugPrint("Fetched Deliveries \(result)")
            switch result {
            case .success(let deliveries):
                deliveries.isEmpty ? completion(.failure(NetworkError.noData)) : completion(.success(deliveries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
