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

enum FetchedDeliveryStatus {
    case fromCache(Int)
    case fromServer
    case faliure(Error)
}

protocol DeliveryListViewModelProtocol {
    var deliveryServices: DeliveryServiceProtocol { get }
    var coreData: CoreDataManagerProtocol { get }

    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func fetchDeliveries(useCache: Bool, completion: @escaping (FetchedDeliveryStatus) -> Void)
}

class DeliveryListViewModel: DeliveryListViewModelProtocol {

    private var currentOffSet = -1
    private var isFetchingDeliveries = false

    var fetchNextDataHandler: ((DeliveryListViewModel) -> Void)?
    var deliveryServices: DeliveryServiceProtocol = DeliveryService()
    var coreData: CoreDataManagerProtocol = CoreDataManager.sharedInstance

    var lastVisibileIndexPath: IndexPath? = nil {
        didSet {
            guard let indexPath = self.lastVisibileIndexPath else { return }
            currentOffSet = indexPath.row + 1
            if shallFetchNextData(indexPath: indexPath) {
                fetchNextDataHandler?(self)
            }
        }
    }

    lazy var frc: NSFetchedResultsController<DeliveryCoreDataModel> = {
        let fetchRequest = self.fetchRequest
        let context = self.coreData.workerManagedContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetchedResultsController Error: \(error.localizedDescription)")
        }
        return fetchedResultsController
    }()

    private lazy var fetchRequest: NSFetchRequest<DeliveryCoreDataModel> = {
        let fetchRequest: NSFetchRequest<DeliveryCoreDataModel> = DeliveryCoreDataModel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "offSet", ascending: true), NSSortDescriptor(key: "identifier", ascending: true)]
        fetchRequest.fetchBatchSize = GlobalConstants.deliveryLimitPerRequest
        return fetchRequest
    }()
}

// MARK: - CoreData Accessors
extension DeliveryListViewModel {

    private func deleteAllDeliveries() {
        coreData.deleteAll(DeliveryCoreDataModel.self)
    }

    private func cacheExists(offSet: Int) -> Bool {
        let predicate = NSPredicate(format: "%K = %@", "offSet", "\(offSet)")
        let deliveries = coreData.fetchData(from: DeliveryCoreDataModel.self, predicate: predicate, moc: coreData.workerManagedContext)
        return !deliveries.isEmpty
    }

    private func saveDeliveries() {
        coreData.saveContext()
    }
}

// MARK: - TableView Wrapper Methods
extension DeliveryListViewModel {

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

// MARK: - Network Accessors
extension DeliveryListViewModel {

    private func shallFetchNextData(indexPath: IndexPath) -> Bool {
        let shallFetch = ((numberOfRows(section: indexPath.section) - 1) == indexPath.row) && !isFetchingDeliveries
        return shallFetch
    }

    func fetchDeliveries(useCache: Bool = true, completion: @escaping (FetchedDeliveryStatus) -> Void) {

        var offSet = useCache ? currentOffSet + GlobalConstants.deliveryLimitPerRequest : 0
        if currentOffSet == -1 && useCache {
            if cacheExists(offSet: 0) {
                completion(.fromCache(0))
                return
            }
            offSet = 0
        } else if useCache && cacheExists(offSet: offSet) {
            completion(.fromCache(offSet))
            return
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
                completion(.fromServer)

            case .failure(let error):
                completion(.faliure(error))
            }
        }
    }

    private func handleFetcedDeliveries(_ deliveries: [Delivery], useCache: Bool) {

        if !useCache {
            deleteAllDeliveries()
        }

        for delivery in deliveries {

            var model: DeliveryCoreDataModel {
                if useCache {
                    return DeliveryCoreDataModel.isExist(with: delivery.identifier, coreData: coreData) ?? DeliveryCoreDataModel.create(coreData: coreData)
                } else {
                    return DeliveryCoreDataModel.create(coreData: coreData)
                }
            }
            model.update(delivery: delivery, offSet: currentOffSet)
        }
    }
}
