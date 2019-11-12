//
//  DeliveryListViewModelMock.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import CoreData
@testable import Deliveries

class DeliveryListViewModelMock: DeliveryListViewModelProtocol {

    var useCache: Bool?
    let deliveryServices: DeliveryServiceProtocol
    let coreData: CoreDataManagerProtocol

    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    var numberOfSectionsMock = 1
    var numberOfRowsMock = 10
    var item:(title: String?, imageURL: String?) = (title: "text", imageURL: "https://www.google.co.in/")
    var fetchNextDataHandler: ((DeliveryListViewModelProtocol) -> Void)?
    var lastVisibileIndexPath: IndexPath?

   lazy var delivery: DeliveryCoreDataModel! = {
        let location = Location.init(lat: 10, lng: 20, address: "london")
        let delivery = Delivery.init(identifier: 100, desc: "this is test", imageUrl: "https://www.google.co.in/", location: location)
        let deliveryModel = DeliveryCoreDataModel.create(coreData: coreData, delivery: delivery)
        return deliveryModel
    }()

    var fetchedDeliveryStatus: FetchedDeliveryStatus = .fromServer

    required init(deliveryServices: DeliveryServiceProtocol, coreData: CoreDataManagerProtocol) {
        self.deliveryServices = deliveryServices
        self.coreData = coreData
    }

    func fetchedObjectsCount() -> Int {
        return numberOfRowsMock
    }

    func numberOfSections() -> Int {
        return numberOfSectionsMock
    }

    func numberOfRows(section: Int) -> Int {
        return numberOfRowsMock
    }

    func item(at indexPath: IndexPath) -> (title: String?, imageURL: String?) {
        return item
    }

    func fetchDeliveries(useCache: Bool, completion: @escaping (FetchedDeliveryStatus) -> Void) {
        self.useCache = useCache
        completion(fetchedDeliveryStatus)
    }

    func delivery(at indexPath: IndexPath) -> DeliveryCoreDataModel {
        return delivery
    }
}
