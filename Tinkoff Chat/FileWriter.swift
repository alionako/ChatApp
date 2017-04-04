//
//  FileWriter.swift
//  Tinkoff Chat
//
//  Created by Aliona on 31/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation
import UIKit

let FILENAME = "UserData"
let EXTENSION = "json"

let IMG_NAME = "UserIcon"
let IMG_EXTENSION = "png"

let NAME_KEY = "Name"
let ABOUT_KEY = "About"
let COLOR_KEY = "Color"

class FileWriter : NSObject {
    
    class func writeData(_ data: [String : AnyObject], image: UIImage?, success: Void, failure: Void) {
        var dataToSave = data
        let storedData = FileReader.getData()
        if storedData != nil {
            for key in storedData!.keys {
                if dataToSave[key] == nil {
                    dataToSave[key] = storedData![key]
                }
            }
        }
        if JSONSerialization.isValidJSONObject(data) {
            do {
                let rawData = try JSONSerialization.data(withJSONObject: dataToSave, options: .prettyPrinted)
                let str = String(data: rawData, encoding: String.Encoding.utf8)
                try str?.write(to: DocumentPathGetter.getPath(), atomically: true, encoding: String.Encoding.utf8)
            
            } catch {
                failure
            }
        }
        if image != nil && image != FileReader.getImage() {
            let pngImageData = UIImagePNGRepresentation(image!)
            do {
                try pngImageData?.write(to: DocumentPathGetter.getImagePath(), options: .atomic)
            } catch {
                failure
            }
        }
        success
    }
}

class FileReader : NSObject {
    class func getData () -> [String: AnyObject]? {
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
    class func getImage() -> UIImage {
        let filePath = DocumentPathGetter.getImagePath().path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        }
        return UIImage.init(named: "UserIconPlaceholder")!
    }
}

class DocumentPathGetter {
    private class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    class func getPath() -> URL {
        let documentsDirectory = self.getDocumentsDirectory()
        let filename = documentsDirectory.appendingPathComponent("\(FILENAME).\(EXTENSION)")
        return filename
    }
    class func getImagePath() -> URL {
        let documentsDirectory = self.getDocumentsDirectory()
        let filename = documentsDirectory.appendingPathComponent("\(IMG_NAME).\(IMG_EXTENSION)")
        return filename
    }
}
