//
//  ChatDataProvider.swift
//  Tinkoff Chat
//
//  Created by Aliona on 29/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit
import CoreData

class ChatDataProvider : NSObject {
    let fetchedResultsController : NSFetchedResultsController<Message>
    let tableView : UITableView
    
    init(tableView: UITableView, conversationId: String) {
        
        self.tableView = tableView
        
        let context = StorageManager.getContext()!
        let model = context.persistentStoreCoordinator?.managedObjectModel
        let fetchRequest = Message.fetchRequestMessages(model: model!, conversationId: conversationId)
        let timeSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest?.sortDescriptors = [timeSortDescriptor]
        fetchedResultsController = NSFetchedResultsController<Message> (fetchRequest: fetchRequest!, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
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

extension ChatDataProvider : NSFetchedResultsControllerDelegate {
    
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

