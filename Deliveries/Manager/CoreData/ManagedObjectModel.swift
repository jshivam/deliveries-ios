//
//  ManagedObjectModel.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 07/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import CoreData

class ManagedObjectModel {
    private init() {}
    static let shared = ManagedObjectModel()
    private(set) lazy var model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Lalamove", withExtension: "momd")!
        let mom = NSManagedObjectModel(contentsOf: modelURL)!
        return mom
    }()
}
