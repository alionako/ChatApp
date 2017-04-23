//
//  MessageServiceProtocol.swift
//  Tinkoff Chat
//
//  Created by Aliona on 22/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

struct User {
    let name: String?
    let online: Bool?
}

struct Message {
    let text: String?
    let user: User?
    let date: Date?
    let new: Bool?
}

protocol MessageServiceProtocol {
    func loadMessages(fromUser: User, completionHandler: @escaping ([Message]?, String?) -> Void)
    func sendMessage(message: Message, completionHandler: @escaping (Bool, String?) -> Void)
    func receiveMessage(completionHandler: @escaping (Message, String?) -> Void)
}
