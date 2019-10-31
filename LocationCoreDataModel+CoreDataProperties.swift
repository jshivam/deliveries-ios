//
//  LocationCoreDataModel+CoreDataProperties.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationCoreDataModel> {
        return NSFetchRequest<LocationCoreDataModel>(entityName: "LocationCoreDataModel")
    }

    @NSManaged public var address: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var delivery: DeliveryCoreDataModel?

}
