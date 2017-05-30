//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Aliona on 24/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contactTable: UITableView!
    
    var dataProvider : ConversationListDataProvider?
    
    var communicator : MultipeerCommunicator? = nil
    var communicationManager : CommunicationManager? = nil
    
    override func viewDidLoad() {
        if communicator == nil {
            communicator = MultipeerCommunicator()
        }
        if communicationManager == nil {
            communicationManager = CommunicationManager()
            communicationManager?.contactListViewController = self
        }
        communicator?.delegate = communicationManager
        dataProvider = ConversationListDataProvider(tableView: contactTable)
    }
    
    // MARK - Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = dataProvider?.fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = dataProvider?.fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessagePreviewCell = tableView.dequeueReusableCell(withIdentifier: "MessagePreviewCell") as! MessagePreviewCell
        
        if let user = dataProvider?.fetchedResultsController.object(at: indexPath) {
            cell.configure(withUser: user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let controller = self.getInitialViewController(fromStoryBoard: "ChatScreen") as! ConversationViewController
        
        let withUser = (cell as! MessagePreviewCell).chatName.text
        controller.title = withUser
        controller.opponent = withUser
        
        controller.communicator = communicator
        controller.communicationManager = communicationManager

        self.show(controller, sender: cell)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let objects = self.dataProvider?.fetchedResultsController.sections?[section].objects {
            if objects.count > 0 {
                if let object = objects[0] as? User {
                    if object.isOnline {
                        return "Online"
                    } else {
                        return "History"
                    }
                }
            }
        }
        return ""
    }
    
    func showAlertWithText(_ text: String) {
        let alert = UIAlertController(title: text, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK - Navigation
    
    @IBAction func openProfile(_ sender: UIBarButtonItem) {
        let controller = self.getInitialViewController(fromStoryBoard: "UserProfile")
        self.show(controller, sender: sender)
    }
    
    private func getInitialViewController(fromStoryBoard: String) -> UIViewController {
        let storyboard = UIStoryboard(name: fromStoryBoard, bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
}
