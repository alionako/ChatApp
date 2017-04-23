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
        
        let dataToSave = UserDataSaver.mapData(data)
        let dataDict = UserDataSaver.getDictionaryFromUserData(dataToSave)
        
        if JSONSerialization.isValidJSONObject(dataDict) {
            do {
                
                let rawData = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
                let str = String(data: rawData, encoding: String.Encoding.utf8)
                try str?.write(to: DocumentPathGetter.getPath(), atomically: true, encoding: String.Encoding.utf8)
                
            } catch {
                failure
            }
        }
        if dataToSave?.image != nil {
            let pngImageData = UIImagePNGRepresentation(dataToSave!.image!)
            do {
                try pngImageData?.write(to: DocumentPathGetter.getImagePath(), options: .atomic)
            } catch {
                failure
            }
        }
        success
    }
    
    static private func getDictionaryFromUserData (_ userData : UserData?) -> [String : AnyObject] {
        var result : [String : AnyObject] = [:]
        
        if userData == nil {
            return result
        }
        
        if userData?.name != nil {
            result[NAME_KEY] = userData?.name as AnyObject
        }
        if userData?.about != nil {
            result[ABOUT_KEY] = userData?.about as AnyObject
        }
        if userData?.color != nil {
            result[COLOR_KEY] = ColorHelper.getColorArrayFromStruct(userData?.color) as AnyObject
        }
        
        return result
    }
    
    static private func mapData(_ dataToSave: UserData?) -> UserData? {
        
        if dataToSave == nil {
            return nil
        }
        
        var mappedData = dataToSave
        let storedData = UserDataRetriever.retrieveData()
        
        if storedData != nil {
            if dataToSave?.name == nil {
                mappedData?.name = storedData?.name
            }
            if dataToSave?.about == nil {
                mappedData?.about = storedData?.about
            }
            if dataToSave?.color == nil {
                mappedData?.color = storedData?.color
            }
            if dataToSave?.image == nil {
                mappedData?.image = storedData?.image
            }
        }
        
        return mappedData
    }
}
