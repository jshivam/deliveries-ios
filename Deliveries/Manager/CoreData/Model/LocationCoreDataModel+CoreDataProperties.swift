//
//  LocationCoreDataModel+CoreDataProperties.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//
//

import Foundation
import CoreData

extension LocationCoreDataModel {

    @NSManaged public var address: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var delivery: DeliveryCoreDataModel?

    static func create(coreData: CoreDataManagerProtocol, location: Location?) -> LocationCoreDataModel {
        let locationObject = coreData.createObject(LocationCoreDataModel.self)
        if let location = location {
            locationObject.address = location.address
            locationObject.lat = location.lat
            locationObject.lng = location.lng
        }
        return locationObject
    }
}
