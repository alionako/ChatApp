//
//  SaveUserDataProtocol.swift
//  Tinkoff Chat
//
//  Created by Aliona on 17/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

protocol SaveUserDataProtocol {
    
    func saveData(data: UserData?, success: @escaping () -> (), failure: @escaping () -> ())
    
}
