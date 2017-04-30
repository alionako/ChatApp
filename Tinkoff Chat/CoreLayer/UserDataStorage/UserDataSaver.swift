//
//  UserDataSaver.swift
//  Tinkoff Chat
//
//  Created by Aliona on 31/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation
import UIKit

let FILENAME = "UserData"
let EXTENSION = "json"

let NAME_KEY = "Name"
let ABOUT_KEY = "About"
let COLOR_KEY = "Color"

let IMG_NAME = "UserIcon"
let IMG_EXTENSION = "png"

struct UserData {
    var name : String? = nil
    var about : String? = nil
    var color : LabelColor? = nil
    var image : UIImage? = nil
}

protocol UserDataSaverProtocol {
    static func saveData(_ data: UserData?, success: Void, failure: Void)
}

class UserDataSaver : UserDataSaverProtocol {
    
    static func saveData(_ data: UserData?, success: Void, failure: Void) {
        
        if data == nil {
            return
        }
        
        let _ = StorageManager.saveUserData(data, success: success)
    }
}
