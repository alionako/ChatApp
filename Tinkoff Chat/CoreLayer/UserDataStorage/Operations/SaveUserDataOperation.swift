//
//  SaveUserDataOperation.swift
//  Tinkoff Chat
//
//  Created by Aliona on 17/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class SaveUserDataOperation : Operation {
    
    private var data : UserData?
    private var vc: ProfileViewController
    
    init (data: UserData?, vc: ProfileViewController) {
        self.data = data
        self.vc = vc
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let success = {
            self.vc.dataToSave = nil
            self.vc.enableButtons(enable: false)
            self.vc.indicator.stopAnimating()
            self.vc.showSaveSuccessAlert()
        }
        
        let failure = {
            self.vc.showSaveFailureAlert { (Void) in
                
            }
        }
        
        UserDataSaver.saveData(self.data, success: success(), failure:  failure())
        
    }
}
