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

    @NSManaged public var address: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var delivery: DeliveryCoreDataModel?

    static func create(coreData: CoreDataManagerProtocol) -> LocationCoreDataModel {
        let location = coreData.createObject(LocationCoreDataModel.self)
        return location
    }

    func update(location: Location) {
        address = location.address
        lat = location.lat
        lng = location.lng
    }
}
