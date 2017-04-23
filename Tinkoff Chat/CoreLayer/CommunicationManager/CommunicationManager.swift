//
//  CommunicationManager.swift
//  Tinkoff Chat
//
//  Created by Aliona on 22/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

class CommunicationManager : CommunicatorDelegate {
    
    var contactListViewController : ConversationsListViewController? = nil
    var contactList : [String : String?]? = nil
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        contactListViewController?.showAlertWithText("Ого, сообщение!!! Текст сообщения: \(text)")
    }
    
    func failedToStartAdvertising(error: Error) {
        contactListViewController?.showAlertWithText("Не удалось включить обнаружение другими устройствами!")
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        contactListViewController?.showAlertWithText("Не удалось начать поиск пользователей!")
    }
    
    func didLostUser(userID: String) {
        contactList?.removeValue(forKey: userID)
        contactListViewController?.contactTable.reloadData()
    }
    
    func didFoundUser(userID: String, userName: String?) {
        contactList = [userID : userName]
        contactListViewController?.contactList = contactList!
        contactListViewController?.contactTable.reloadData()
    }
}
