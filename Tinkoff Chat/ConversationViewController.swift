//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Aliona on 26/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ConversationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var dataSource : [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 100
        
        self.dataSource = [" ", "Сообщение номер 2", "Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение"]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataSource?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageBubbleCell = tableView.dequeueReusableCell(withIdentifier: "MessageBubbleCell") as! MessageBubbleCell
        cell.txt = dataSource?[indexPath.row]
        return cell
    }
}
