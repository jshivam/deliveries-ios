//
//  ManagedObjectModel.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import CoreData

class ManagedObjectModel {

    struct Constant {
        static let fileName = "Lalamove"
    }

    private init() {}
    static let shared = ManagedObjectModel()
    private(set) lazy var model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: Constant.fileName, withExtension: "momd")!
        let mom = NSManagedObjectModel(contentsOf: modelURL)!
        return mom
    }()
}
