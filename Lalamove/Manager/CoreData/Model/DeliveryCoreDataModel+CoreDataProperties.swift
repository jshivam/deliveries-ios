//
//  DeliveryCoreDataModel+CoreDataProperties.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData


extension DeliveryCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeliveryCoreDataModel> {
        return NSFetchRequest<DeliveryCoreDataModel>(entityName: "DeliveryCoreDataModel")
    }

    @NSManaged public var desc: String?
    @NSManaged public var identifier: Int64
    @NSManaged public var imageUrl: String?
    @NSManaged public var offSet: Int64
    @NSManaged public var location: LocationCoreDataModel?

    // Key is combination of endpoint, limit & offset
    @discardableResult
    func generateKey() -> String {
        return "\(Endpoint.deliveries.rawValue)_\(Contants.deliveryLimitPerRequest)_\(offSet)"
    }
    
    static func create() -> DeliveryCoreDataModel
    {
        let delivery = CoreDataManager.sharedInstance.createObject(DeliveryCoreDataModel.self)
        
        let location = LocationCoreDataModel.create()
        delivery.location = location
        
        return delivery
    }
    
    func update(delivery: Delivery, offSet: Int){
        desc = delivery.desc
        identifier = Int64(delivery.identifier)
        imageUrl = delivery.imageUrl
        self.offSet = Int64(offSet)
        location?.update(location: delivery.location)
    }
}
