//
//  CommunicatorDelegate.swift
//  Tinkoff Chat
//
//  Created by Aliona on 22/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

protocol CommunicatorDelegate : class {
    //discovering
    func didFoundUser(userID : String, userName : String?)
    func didLostUser(userID : String)
    
    //errors
    func failedToStartBrowsingForUsers(error : Error)
    func failedToStartAdvertising(error : Error)
    
    //messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}
