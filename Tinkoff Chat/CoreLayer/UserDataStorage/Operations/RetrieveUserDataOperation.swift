//
//  RetrieveUserDataOperation.swift
//  Tinkoff Chat
//
//  Created by Aliona on 23/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

class RetrieveUserDataOperation : Operation {
    
    private var vc: ProfileViewController
    private var completion: (UserData?) -> Void
    
    init (vc: ProfileViewController, completion: @escaping (UserData?) -> Void) {
        self.vc = vc
        self.completion = completion
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let retrievedData : UserData? = UserDataRetriever.retrieveData()
        
        let queue = OperationQueue.main
        queue.addOperation {
            self.completion(retrievedData)
        }
    }
}
