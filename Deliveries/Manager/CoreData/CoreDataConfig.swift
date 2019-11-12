//
//  CoreDataConfig.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import CoreData

protocol CoreDataConfigProtocol {
    var persistentStore: String { get }

}
class CoreDataConfig: CoreDataConfigProtocol {
    let persistentStore: String
    init(persistentStore: String = NSSQLiteStoreType) {
        self.persistentStore = persistentStore
    }
}
