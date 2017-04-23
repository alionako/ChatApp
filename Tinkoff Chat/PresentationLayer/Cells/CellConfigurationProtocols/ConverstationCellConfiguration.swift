//
//  ConverstationCellConfiguration.swift
//  Tinkoff Chat
//
//  Created by Aliona on 26/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

protocol ConverstationCellConfiguration : class {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}
