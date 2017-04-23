//
//  MessageIdGenerator.swift
//  Tinkoff Chat
//
//  Created by Aliona on 22/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

protocol MessageIdGeneratorProtocol {
    static func generateMessageId() -> String
}

class MessageIdGenerator : MessageIdGeneratorProtocol {
    static func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT_FAST32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT_FAST32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
