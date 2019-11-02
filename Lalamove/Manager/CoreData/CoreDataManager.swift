//
//  CoreDataManager.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {

    static let sharedInstance = CoreDataManager()
    private let fileName = "Lalamove"

    private(set) lazy var applicationDocDir: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let endIndex = urls.index(before: urls.endIndex)
        return urls[endIndex]
    }()

    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: fileName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let sqlFileName = fileName + ".sqlite"
        let url = self.applicationDocDir.appendingPathComponent(sqlFileName)

        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            print(error)
            abort()
        }
        return coordinator
    }()

    private(set) lazy var mainContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = coordinator
        return moc
    }()

    private(set) lazy var workerManagedContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.parent = self.mainContext
        return moc
    }()

    private(set) lazy var networkManagedContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = self.workerManagedContext
        return moc
    }()

    func saveContext() {
        self.networkManagedContext.perform {
            self.networkManagedContext.saveIfhasChanges()
            self.workerManagedContext.perform({
                self.workerManagedContext.saveIfhasChanges()
                self.mainContext.perform({
                    self.mainContext.saveIfhasChanges()
                })
            })
        }
    }

    func saveContexAndWait() {
        self.networkManagedContext.performAndWait {
            self.networkManagedContext.saveIfhasChanges()
            self.workerManagedContext.performAndWait({
                self.workerManagedContext.saveIfhasChanges()
                self.mainContext.performAndWait({
                    self.mainContext.saveIfhasChanges()
                })
            })
        }
    }

    func deleteAll<T: NSManagedObject>(_ anyClass: T.Type) {
        let context = networkManagedContext
        let name = className(anyClass)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.includesPropertyValues = false

        do {
            let items = try context.fetch(fetchRequest) as! [T] // swiftlint:disable:this force_cast
            for item in items {
                context.delete(item)
            }
            saveContext()
        } catch {
            print("Errod deleting...")
        }
    }

    func deleteObject(_ item: NSManagedObject) {
        let itemId = item.objectID
        let object = networkManagedContext.object(with: itemId)
        networkManagedContext.delete(object)
        saveContext()
    }

    func deleteObjects(_ items: [NSManagedObject]) {
        let context = networkManagedContext
        for item in items {
            let itemId = item.objectID
            let object = context.object(with: itemId)
            context.delete(object)
        }
        saveContext()
    }

    func createObject<T: NSManagedObject>(_ anyClass: T.Type) -> T {
        let context = networkManagedContext
        let name = className(anyClass)
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        return object as! T // swiftlint:disable:this force_cast
    }

    func fetchData<T: NSManagedObject>(from classs: T.Type,
                                       predicate: NSPredicate? = nil,
                                       moc: NSManagedObjectContext = CoreDataManager.sharedInstance.workerManagedContext ) -> [T] {
        let context = moc
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: className(classs))
        request.predicate = predicate

        do {
            let result = try context.fetch(request)
            return result as! [T] // swiftlint:disable:this force_cast
        } catch {
            print("Failed to fetch")
        }
        return []
    }

    private func className(_ anyClass: AnyClass) -> String {
        let name = NSStringFromClass(anyClass).components(separatedBy: ".").last!
        return name
    }
}

extension NSManagedObjectContext {
    func saveIfhasChanges() {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                fatalError("Error : \(error.localizedDescription)")
            }
        }
    }
}
