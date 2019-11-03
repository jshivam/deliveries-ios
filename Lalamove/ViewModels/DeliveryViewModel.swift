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

protocol DeliveryViewModelProtocol {
    var currentOffSet: Int { get }
    var deliveryServices: DeliveryService { get }
    var isFetchingDeliveries: Bool { get }

    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func heightForRow() -> CGFloat
    func deleteAllDeliveries()
    func resetState()
    func cacheExists(offSet: Int) -> Bool
    func shallFetchNextData(indexPath: IndexPath) -> Bool
    func fetchDeliveries(useCache: Bool, completion: @escaping (Error?) -> Void)
    func saveDeliveries()
}

class DeliveryViewModel: DeliveryViewModelProtocol {

    let context = CoreDataManager.sharedInstance.workerManagedContext
    var currentOffSet = -1
    let deliveryServices = DeliveryService.init()
    var isFetchingDeliveries = false
    lazy var frc: NSFetchedResultsController<DeliveryCoreDataModel> = {
        let fetchRequest = self.fetchRequest
        let context = self.context
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

    func heightForRow() -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DeliveryViewModel {

    func deleteAllDeliveries() {
        CoreDataManager.sharedInstance.deleteAll(DeliveryCoreDataModel.self)
        resetState()
    }

    func resetState() {
        currentOffSet = -1
    }

    func cacheExists(offSet: Int) -> Bool {
        let predicate = NSPredicate(format: "%K = %@", "offSet", "\(offSet)")
        let deliveries = CoreDataManager.sharedInstance.fetchData(from: DeliveryCoreDataModel.self, predicate: predicate)
        return !deliveries.isEmpty
    }

    func shallFetchNextData(indexPath: IndexPath) -> Bool {
        return ((numberOfRows(section: indexPath.section) - 1) == indexPath.row) && !isFetchingDeliveries
    }

    func fetchDeliveries(useCache: Bool = true, completion: @escaping (Error?) -> Void) {

        var offSet = currentOffSet + Constants.deliveryLimitPerRequest
        if currentOffSet == -1 {
            if useCache && cacheExists(offSet: 0) {
                completion(nil)
                return
            }
            offSet = 0
        }
        isFetchingDeliveries = true
        deliveryServices.fetchDeliveries(offSet: offSet, limit: Constants.deliveryLimitPerRequest) { [weak self] (result) in
            self?.isFetchingDeliveries = false
            switch result {
            case .success(let deliveries):
                for delivery in deliveries {
                    let model = DeliveryCoreDataModel.create()
                    model.update(delivery: delivery, offSet: offSet)
                }
                self?.saveDeliveries()
                self?.currentOffSet = offSet
                completion(nil)

            case .failure(let error):
                completion(error)
            }
        }
    }

    func saveDeliveries() {
        CoreDataManager.sharedInstance.saveContext()
    }
}
