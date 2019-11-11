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

    @discardableResult
    static func create(coreData: CoreDataManagerProtocol, delivery: Delivery?) -> DeliveryCoreDataModel {
        let deliveryObject = coreData.createObject(DeliveryCoreDataModel.self)
        if let delivery = delivery {
            deliveryObject.desc = delivery.desc
            deliveryObject.identifier = Int64(delivery.identifier)
            deliveryObject.imageUrl = delivery.imageUrl
            let locationObject = LocationCoreDataModel.create(coreData: coreData, location: delivery.location)
            deliveryObject.location = locationObject
        }
        return deliveryObject
    }
}
