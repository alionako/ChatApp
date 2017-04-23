//
//  Communicator.swift
//  Tinkoff Chat
//
//  Created by Aliona on 22/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler:
        ((_ success : Bool, _ error: Error?) -> ())?)
    weak var delegate : CommunicatorDelegate? {get set}
    var online : Bool {get set}
}
