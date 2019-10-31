//
//  ViewController.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let network = Network(sessionConfiguration: APISessionConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.fetchService().fetchDeliveries { (delivries, error) in
//            print(error)
//            print(delivries)
        }
    }
}

class Network {
    private var sessionConfiguration: APISessionConfigurationProtocol
    private let apiPerformer: APIPerformerProtocol = APIPerformer()
    
    
    init(sessionConfiguration: APISessionConfigurationProtocol) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    // Expose Services
    func fetchService() -> DeliveryServiceProtocol {
        return DeliveryService(apiPerformer: apiPerformer, sessionConfiguration: sessionConfiguration)
    }
}

