//
//  DeliveryViewModel.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol DeliveryListViewModelProtocol {
    var currentOffSet: Int { get }
    var deliveryServices: DeliveryServiceProtocol { get }
    var isFetchingDeliveries: Bool { get }

    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func deleteAllDeliveries()
    func cacheExists(offSet: Int) -> Bool
    func shallFetchNextData(indexPath: IndexPath) -> Bool
    func fetchDeliveries(useCache: Bool, completion: @escaping (Error?) -> Void)
    func saveDeliveries()
}

class DeliveryListViewModel: DeliveryListViewModelProtocol {
    var lastVisibileIndexPath: IndexPath? = nil {
        didSet {
            guard let indexPath = self.lastVisibileIndexPath, shallFetchNextData(indexPath: indexPath) else { return }
            fetchNextDataHandler?(self)
        }
    }
    var fetchNextDataHandler: ((DeliveryListViewModel) -> Void)?

    var currentOffSet = -1
    let deliveryServices: DeliveryServiceProtocol = DeliveryService.init()
    var isFetchingDeliveries = false
    lazy var frc: NSFetchedResultsController<DeliveryCoreDataModel> = {
        let fetchRequest = self.fetchRequest
        let context = CoreDataManager.sharedInstance.workerManagedContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        return fetchedResultsController
    }()

    private lazy var fetchRequest: NSFetchRequest<DeliveryCoreDataModel> = {
        let fetchRequest: NSFetchRequest<DeliveryCoreDataModel> = DeliveryCoreDataModel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "offSet", ascending: true), NSSortDescriptor(key: "identifier", ascending: true)]
        return fetchRequest
    }()

    func numberOfSections() -> Int {
        let count = frc.sections?.count ?? 0
        return count
    }

    func numberOfRows(section: Int) -> Int {
        let sectionInfo = frc.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func item(at indexPath: IndexPath) -> (title: String?, imageURL: String?) {
        let delivery = frc.object(at: indexPath)
        return (title: delivery.desc, imageURL: delivery.imageUrl)
    }
}

extension DeliveryListViewModel {

    func deleteAllDeliveries() {
        CoreDataManager.sharedInstance.deleteAll(DeliveryCoreDataModel.self)
    }

    func cacheExists(offSet: Int) -> Bool {
        let predicate = NSPredicate(format: "%K = %@", "offSet", "\(offSet)")
        let deliveries = CoreDataManager.sharedInstance.fetchData(from: DeliveryCoreDataModel.self, predicate: predicate)
        return !deliveries.isEmpty
    }

    func shallFetchNextData(indexPath: IndexPath) -> Bool {
        let shallFetch = ((numberOfRows(section: indexPath.section) - 1) == indexPath.row) && !isFetchingDeliveries
        return shallFetch
    }

    func fetchDeliveries(useCache: Bool = true, completion: @escaping (Error?) -> Void) {

        var offSet = useCache ? currentOffSet + GlobalConstants.deliveryLimitPerRequest : 0
        if currentOffSet == -1 && useCache {
            if cacheExists(offSet: 0) {
                completion(nil)
                return
            }
            offSet = 0
        }
        isFetchingDeliveries = true
        deliveryServices.fetchDeliveries(offSet: offSet, limit: GlobalConstants.deliveryLimitPerRequest) { [weak self] (result) in

            guard let `self` = self else { return }

            self.isFetchingDeliveries = false
            switch result {
            case .success(let deliveries):
                self.currentOffSet = offSet - (GlobalConstants.deliveryLimitPerRequest - deliveries.count)
                self.handleFetcedDeliveries(deliveries, useCache: useCache)
                self.saveDeliveries()
                completion(nil)

            case .failure(let error):
                completion(error)
            }
        }
    }

    func handleFetcedDeliveries(_ deliveries: [Delivery], useCache: Bool) {

        if !useCache {
            deleteAllDeliveries()
        }

        for delivery in deliveries {

            var model: DeliveryCoreDataModel {
                if useCache {
                    return DeliveryCoreDataModel.isExist(with: delivery.identifier) ?? DeliveryCoreDataModel.create()
                } else {
                    return DeliveryCoreDataModel.create()
                }
            }
            model.update(delivery: delivery, offSet: currentOffSet)
        }
    }

    func saveDeliveries() {
        CoreDataManager.sharedInstance.saveContext()
    }
}
