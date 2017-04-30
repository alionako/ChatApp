//
//  MessageServiceProtocol.swift
//  Tinkoff Chat
//
//  Created by Aliona on 22/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

struct UserStruct {
    let name: String?
    let online: Bool?
}

struct MessageStruct {
    let text: String?
    let user: UserStruct?
    let date: Date?
    let new: Bool?
}

protocol MessageServiceProtocol {
    func loadMessages(fromUser: UserStruct, completionHandler: @escaping ([MessageStruct]?, String?) -> Void)
    func sendMessage(message: MessageStruct, completionHandler: @escaping (Bool, String?) -> Void)
    func receiveMessage(completionHandler: @escaping (MessageStruct, String?) -> Void)
}
