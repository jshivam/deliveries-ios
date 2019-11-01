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

class DeliveryViewModel
{
    var currentOffSet = -1
    let deliveryServices = DeliveryService.init()
    
    private let context = CoreDataManager.sharedInstance.workerManagedContext
    
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

extension DeliveryViewModel
{
    func cacheExists(offSet: Int) -> Bool {
        let predicate = NSPredicate(format: "%K = %@", "offSet", "\(offSet)")
        let deliveries = CoreDataManager.sharedInstance.fetchData(from: DeliveryCoreDataModel.self, predicate: predicate)
        return !deliveries.isEmpty
    }
    
    func isLastCell(indexPath: IndexPath) -> Bool{
        return ((numberOfRows(section: indexPath.section) - 1) == indexPath.row)
    }
    
    func fetchDeliveries()
    {
        var offSet = currentOffSet + Contants.deliveryLimitPerRequest
        
        if currentOffSet == -1 {
            if cacheExists(offSet: 0) {
                return
            }
            offSet = 0
        }
        
        deliveryServices.fetchDeliveries(offSet: offSet, limit: Contants.deliveryLimitPerRequest) { [weak self] (deliveries, error) in
            if error != nil {
                print("Error fetching....")
                return
            }
            
            if let deliveries = deliveries {
                for delivery in deliveries {
                    let model = DeliveryCoreDataModel.create()
                    model.update(delivery: delivery, offSet: offSet)
                }
            }
            self?.saveDeliveries()
            self?.currentOffSet = offSet
        }
    }
    
    func saveDeliveries(){
        CoreDataManager.sharedInstance.saveContext()
    }
}
