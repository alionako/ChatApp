//
//  UserDataRetriever.swift
//  Tinkoff Chat
//
//  Created by Aliona on 17/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

protocol UserDataRetrieverProtocol {
    static func retrieveData() -> UserData?
}

class UserDataRetriever : UserDataRetrieverProtocol {
    
    static func retrieveData() -> UserData? {
        var result : UserData? = UserData.init()
        
        let infoData = UserDataRetriever.getData()
        if infoData != nil {
            result?.name = infoData![NAME_KEY] as? String
            result?.about = infoData![ABOUT_KEY] as? String
            let color = infoData![COLOR_KEY] as? [CGFloat]
            if color != nil {
                result?.color = ColorHelper.getColorStructFromArray(color!)
            }
        }
        
        result?.image = UserDataRetriever.getImage()
        
        return result
    }
    
    static private func getData () -> [String: AnyObject]? {
        let data = NSData(contentsOf: DocumentPathGetter.getPath())
        guard data != nil else {
            return nil
        }
        let json = try? JSONSerialization.jsonObject(with: data! as Data, options: [])
        if let object = json as? [String: AnyObject] {
            return object
        }
        return nil
    }
    
    static private func getImage() -> UIImage? {
        let filePath = DocumentPathGetter.getImagePath().path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        }
        return nil
    }
}
