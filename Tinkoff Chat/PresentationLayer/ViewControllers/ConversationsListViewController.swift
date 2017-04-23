//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Aliona on 24/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contactTable: UITableView!
    
    var contactList : [String : String?]?
    
    var communicator : MultipeerCommunicator? = nil
    var communicationManager : CommunicationManager? = nil
    
    override func viewDidLoad() {
        if contactList == nil {
            contactList = [:]
        }
        if communicator == nil {
            communicator = MultipeerCommunicator()
        }
        if communicationManager == nil {
            communicationManager = CommunicationManager()
            communicationManager?.contactListViewController = self
        }
        communicator?.delegate = communicationManager
    }
    
    // MARK - Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MessagePreviewCell = tableView.dequeueReusableCell(withIdentifier: "MessagePreviewCell") as! MessagePreviewCell
        
        let index = indexPath.row
        let key = [String](contactList!.keys)[index]
        cell.chatName.text = contactList![key]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let controller = self.getInitialViewController(fromStoryBoard: "ChatScreen")
        controller.title = (cell as! MessagePreviewCell).chatName.text
        self.show(controller, sender: cell)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return ""
        }
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
