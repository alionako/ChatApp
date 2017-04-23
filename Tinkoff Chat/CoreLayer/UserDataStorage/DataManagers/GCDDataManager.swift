//
//  Multithreading.swift
//  Tinkoff Chat
//
//  Created by Aliona on 04/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class GCDDataManager: SaveUserDataProtocol, RetrieveUserDataProtocol {
    
    func saveData(data: UserData?, success: @escaping () -> (), failure: @escaping () -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            UserDataSaver.saveData(data, success: {
                DispatchQueue.main.async {
                    success()
                }
            }(), failure: {
                DispatchQueue.main.async {
                    failure()
                }
            }())
        }
    }
    
    func retrieveData(setDataFunction: @escaping (UserData?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let savedData = UserDataRetriever.retrieveData()
            DispatchQueue.main.async {
                setDataFunction(savedData)
            }
        }
    }
}
