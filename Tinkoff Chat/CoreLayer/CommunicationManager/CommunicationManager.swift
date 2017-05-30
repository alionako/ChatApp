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
    var chatViewController : ConversationViewController? = nil
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        contactListViewController?.showAlertWithText("Ого, сообщение от пользователя \(fromUser)!!! Текст сообщения: \(text)")
    }
    
    func failedToStartAdvertising(error: Error) {
        contactListViewController?.showAlertWithText("Не удалось включить обнаружение другими устройствами!")
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        contactListViewController?.showAlertWithText("Не удалось начать поиск пользователей!")
    }
    
    func didLostUser(userID: String) {
        let _ = User.changeUserState(userId: userID, online: false, completion: self.updateResults())
        chatViewController?.animateTitle(connected: false)
    }
    
    func didFoundUser(userID: String, userName: String?) {
        let _ = User.saveUser(id: userID, name: userID, completion: self.updateResults())
        chatViewController?.animateTitle(connected: true)
    }
    
    func updateResults() {
        do {
            try contactListViewController?.dataProvider?.fetchedResultsController.performFetch()
            try chatViewController?.dataProvider?.fetchedResultsController.performFetch()
        } catch {
            print("Failed to perform fetch")
        }
        contactListViewController?.dataProvider?.fetchResults()
        chatViewController?.dataProvider?.fetchResults()
    }
}
