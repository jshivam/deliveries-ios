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

protocol DeliveryListViewModelProtocol: AnyObject {

    init(deliveryServices: DeliveryServiceProtocol, coreData: CoreDataManagerProtocol)

    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func item(at indexPath: IndexPath) -> (title: String?, imageURL: String?)

    func delivery(at indexPath: IndexPath) -> DeliveryCoreDataModel
    func fetchedObjectsCount() -> Int

    func fetchDeliveries(useCache: Bool, completion: @escaping (FetchedDeliveryStatus) -> Void)

    var fetchNextDataHandler: ((DeliveryListViewModelProtocol) -> Void)? { get set }
    var lastVisibileIndexPath: IndexPath? { get set }
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate? { get set }
}

class DeliveryListViewModel: DeliveryListViewModelProtocol {

    private struct Constants {
        static let offSetKey = "offSet"
        static let idKey = "identifier"
    }

    private let deliveryServices: DeliveryServiceProtocol
    private let coreData: CoreDataManagerProtocol
    private var currentOffSet = -1
    private var isFetchingDeliveries = false

    private lazy var frc: NSFetchedResultsController<DeliveryCoreDataModel> = {
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
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.offSetKey, ascending: true),
                                        NSSortDescriptor(key: Constants.idKey, ascending: true)]
            fetchRequest.fetchBatchSize = GlobalConstants.deliveryLimitPerRequest
            return fetchRequest
       }()

    var fetchNextDataHandler: ((DeliveryListViewModelProtocol) -> Void)?
    var lastVisibileIndexPath: IndexPath? = nil {
        didSet {
            guard let indexPath = self.lastVisibileIndexPath else { return }
            currentOffSet = indexPath.row + 1
            if shallFetchNextData(indexPath: indexPath) {
                fetchNextDataHandler?(self)
            }
        }
    }

    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate? {
        didSet {
            self.frc.delegate = self.fetchedResultsControllerDelegate
        }
    }

    required init(deliveryServices: DeliveryServiceProtocol, coreData: CoreDataManagerProtocol) {
        self.coreData = coreData
        self.deliveryServices = deliveryServices
    }
}

// MARK: - CoreData Accessors
extension DeliveryListViewModel {

    private func deleteAllDeliveries() {
        coreData.deleteAll(DeliveryCoreDataModel.self)
    }

    private func cacheExists(offSet: Int) -> Bool {
        let predicate = NSPredicate(format: "\(Constants.offSetKey) == \(offSet)")
        let deliveries = coreData.fetchData(from: DeliveryCoreDataModel.self, predicate: predicate, moc: coreData.workerManagedContext)
        return !deliveries.isEmpty
    }

    private func saveDeliveries() {
        coreData.saveContext()
    }

    func delivery(at indexPath: IndexPath) -> DeliveryCoreDataModel {
        let delivery = frc.object(at: indexPath)
        return delivery
    }

    func fetchedObjectsCount() -> Int {
        return frc.fetchedObjects?.count ?? 0
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
        let delivery = self.delivery(at: indexPath)
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

        var offSet = useCache ? currentOffSet : 0
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
                if useCache, let deliveyModel = getDeliveryCoreDataModelIfExists(with: delivery.identifier) {
                    return deliveyModel
                } else {
                    return DeliveryCoreDataModel.create(coreData: coreData, delivery: delivery)
                }
            }
        }
    }

    private func getDeliveryCoreDataModelIfExists(with id: Int) -> DeliveryCoreDataModel? {
        let predicate = NSPredicate(format: "identifier == \(id)")
        let delivery = coreData.fetchData(from: DeliveryCoreDataModel.self, predicate: predicate, moc: coreData.networkManagedContext)
        return delivery.first
    }
}
