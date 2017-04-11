//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Aliona on 24/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataSource : [[[String : AnyObject]]]?
    
    override func viewDidLoad() {
        dataSource = [
            [
                [
                    "hasUnreadMessages" : false as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "Пишу тебе с приветом" as AnyObject,
                    "date" : Date() as AnyObject
                    
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "Сообщение 1" as AnyObject,
                    "message" : "Новое сообщение" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -1, to: Date()) as AnyObject
                    
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "Сообщение 2" as AnyObject,
                    "message" : "" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .hour, value: -8, to: Date()) as AnyObject
                    
                ],
                [
                    "hasUnreadMessages" : false as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "заголовок" as AnyObject,
                    "message" : "Очень длинное сообщение" as AnyObject,
                    "date" : Date() as AnyObject
                    
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "Сообщение 1" as AnyObject,
                    "message" : "Новое сообщение" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -1, to: Date()) as AnyObject
                    
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "Сообщение" as AnyObject,
                    "message" : "Кое-что интересное" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .hour, value: -8, to: Date()) as AnyObject
                    
                ],
                [
                    "hasUnreadMessages" : false as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "заголовок" as AnyObject,
                    "message" : "Очень длинное сообщение" as AnyObject,
                    "date" : Date() as AnyObject
                    
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "Сообщение 1" as AnyObject,
                    "message" : "Новое сообщение" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -1, to: Date()) as AnyObject
                    
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "Сообщение 1" as AnyObject,
                    "message" : "Новое сообщение" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -1, to: Date()) as AnyObject
                    
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : true as AnyObject,
                    "name" : "Сообщение" as AnyObject,
                    "message" : "Кое-что интересное" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .hour, value: -8, to: Date()) as AnyObject
                    
                ]
            ],
            [
                [
                    "hasUnreadMessages" : false as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "Пишу тебе с приветом" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .hour, value: -3, to: Date()) as AnyObject
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "Пишу тебе с приветом" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -3, to: Date()) as AnyObject
                ],
                [
                    "hasUnreadMessages" : false as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -3, to: Date()) as AnyObject
                ],
                [
                    "hasUnreadMessages" : false as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "Пишу тебе с приветом" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .hour, value: -3, to: Date()) as AnyObject
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "Пишу тебе с приветом" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -3, to: Date()) as AnyObject
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "Пишу тебе с приветом" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -3, to: Date()) as AnyObject
                ],
                [
                    "hasUnreadMessages" : false as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -3, to: Date()) as AnyObject
                ],
                [
                    "hasUnreadMessages" : false as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "Пишу тебе с приветом" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .hour, value: -3, to: Date()) as AnyObject
                ],
                [
                    "hasUnreadMessages" : true as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "Пишу тебе с приветом" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -3, to: Date()) as AnyObject
                ],
                [
                    "hasUnreadMessages" : false as AnyObject,
                    "online" : false as AnyObject,
                    "name" : "Ололо" as AnyObject,
                    "message" : "" as AnyObject,
                    "date" : Calendar.current.date(byAdding: .day, value: -3, to: Date()) as AnyObject
                ]
            ]
        ]
    }
    
    // MARK - Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource![section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MessagePreviewCell = tableView.dequeueReusableCell(withIdentifier: "MessagePreviewCell") as! MessagePreviewCell
        
        let currentValue = dataSource![indexPath.section][indexPath.row]
        cell.online = currentValue["online"] as! Bool
        cell.hasUnreadMessages = currentValue["hasUnreadMessages"] as! Bool
        cell.name = currentValue["name"] as? String
        cell.message = currentValue["message"] as? String
        cell.date = currentValue["date"] as? Date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "openChat", sender: cell)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChat" {
            let vc : UIViewController = segue.destination
            vc.title = (sender as! MessagePreviewCell).chatName.text
        }
    }
    
}
