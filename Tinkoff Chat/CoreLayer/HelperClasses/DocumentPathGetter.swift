//
//  DocumentPathGetter.swift
//  Tinkoff Chat
//
//  Created by Aliona on 17/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

protocol DocumentPathGetterProtocol {
    static func getPath() -> URL
    static func getImagePath() -> URL
}

class DocumentPathGetter : DocumentPathGetterProtocol {
    
    private class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    static func getPath() -> URL {
        let documentsDirectory = self.getDocumentsDirectory()
        let filename = documentsDirectory.appendingPathComponent("\(FILENAME).\(EXTENSION)")
        return filename
    }
    static func getImagePath() -> URL {
        let documentsDirectory = self.getDocumentsDirectory()
        let filename = documentsDirectory.appendingPathComponent("\(IMG_NAME).\(IMG_EXTENSION)")
        return filename
    }
}
