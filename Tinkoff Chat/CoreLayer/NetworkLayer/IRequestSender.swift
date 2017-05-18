//
//  IRequestSender.swift
//  Tinkoff Chat
//
//  Created by Aliona on 18/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

enum Result {
    case Success(UIImage)
    case Fail(String)
}

protocol IRequestSender {
    func send(requestNumber: Int, completionHandler: @escaping (Result) -> Void)
}
