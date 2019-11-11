//
//  CoreDataMockConfig.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 07/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import CoreData
@testable import Deliveries

class CoreDataMockConfig: CoreDataConfigProtocol {
    let persistentStore: String = NSInMemoryStoreType
}
