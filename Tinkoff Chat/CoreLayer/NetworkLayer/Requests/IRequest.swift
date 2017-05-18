//
//  IRequest.swift
//  Tinkoff Chat
//
//  Created by Aliona on 17/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

protocol IRequest {
    func urlStringForId(_ id: Int) -> String
}
