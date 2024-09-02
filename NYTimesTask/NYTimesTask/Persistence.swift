//
//  Persistence.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import CoreData

class PersistenceManager {
    init() {}

    static var shared = PersistenceManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NYTimesTask")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetch<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try PersistenceManager.shared.context.fetch(managedObject.fetchRequest()) as? [T] else {
                return nil
            }

            return result
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
}
