//
//  ListViewController + Database.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 03/09/24.
//

import CoreData
import UIKit

// MARK: Saving Local DB

extension ListViewController: NSFetchedResultsControllerDelegate {
    func createListEntityFrom(model: ResultModel) -> NSManagedObject? {
        let context = PersistenceManager.shared.persistentContainer.viewContext
        if let responseEntity = NSEntityDescription.insertNewObject(forEntityName: "NYTimesDataModel", into: context) as? NYTimesDataModel {
            responseEntity.title = model.title
            responseEntity.newsPublishedDate = model.publishedDate
            responseEntity.newsUpdatedDate = model.updated
            responseEntity.author = model.byline
            responseEntity.url = model.url
            responseEntity.imageUrl = model.media.last?.mediaMetadata.last?.url
            return responseEntity
        }
        return nil
    }

    func clearData() {
        do {
            let context = PersistenceManager.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: NYTimesDataModel.self))
            do {
                let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map { $0.map { context.delete($0) }}
                PersistenceManager.shared.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    func saveInCoreDataWith(array: DataResponseModel) {
        _ = array.compactMap { self.createListEntityFrom(model: $0) }
        do {
            try PersistenceManager.shared.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        UIView.performWithoutAnimation {
            tableView.performBatchUpdates({
                self.tableView.endUpdates()
            }, completion: nil)
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        UIView.performWithoutAnimation {
            tableView.performBatchUpdates({
                self.tableView.beginUpdates()
            }, completion: nil)
        }
    }
}
