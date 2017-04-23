//
//  RetrieveUserDataProtocol.swift
//  Tinkoff Chat
//
//  Created by Aliona on 23/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

protocol RetrieveUserDataProtocol {

    func retrieveData(setDataFunction: @escaping (UserData?) -> ())
    
}
