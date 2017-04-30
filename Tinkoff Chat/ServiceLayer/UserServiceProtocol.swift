//
//  UserServiceProtocol.swift
//  Tinkoff Chat
//
//  Created by Aliona on 23/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers(completionHandler: @escaping ([UserStruct]?, String?) -> Void)
}
