//
//  CnversationListDataProvider.swift
//  Tinkoff Chat
//
//  Created by Aliona on 13/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit
import CoreData

class ConversationListDataProvider : NSObject {
    let fetchedResultsController : NSFetchedResultsController<User>
    let tableView : UITableView
    
    init(tableView: UITableView) {
        
        self.tableView = tableView
        
        let context = StorageManager.getContext()!
        let model = context.persistentStoreCoordinator?.managedObjectModel
        let fetchRequest = User.fetchRequestUsers(model: model!)
        let onlineSortDescriptor = NSSortDescriptor(key: "isOnline", ascending: true)
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest?.sortDescriptors = [onlineSortDescriptor, nameSortDescriptor]
        fetchedResultsController = NSFetchedResultsController<User> (fetchRequest: fetchRequest!, managedObjectContext: context, sectionNameKeyPath: "isOnline", cacheName: nil)
        
        super.init()
        fetchedResultsController.delegate = self
        self.fetchResults()
    }
    
    func fetchResults() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
}

extension ConversationListDataProvider : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            break
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            break
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
}
