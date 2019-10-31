//
//  DeliveryCache+CoreDataProperties.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData


extension DeliveryCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeliveryCache> {
        return NSFetchRequest<DeliveryCache>(entityName: "DeliveryCache")
    }

    @NSManaged public var limit: Int16
    @NSManaged public var offSet: Int16
    @NSManaged public var deliveries: NSSet?

}

// MARK: Generated accessors for deliveries
extension DeliveryCache {

    @objc(addDeliveriesObject:)
    @NSManaged public func addToDeliveries(_ value: DeliveryCoreDataModel)

    @objc(removeDeliveriesObject:)
    @NSManaged public func removeFromDeliveries(_ value: DeliveryCoreDataModel)

    @objc(addDeliveries:)
    @NSManaged public func addToDeliveries(_ values: NSSet)

    @objc(removeDeliveries:)
    @NSManaged public func removeFromDeliveries(_ values: NSSet)

}
