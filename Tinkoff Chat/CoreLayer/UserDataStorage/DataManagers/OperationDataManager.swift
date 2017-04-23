//
//  OperationDataManager.swift
//  Tinkoff Chat
//
//  Created by Aliona on 17/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class OperationDataManager: SaveUserDataProtocol, RetrieveUserDataProtocol {
    
    var viewController : ProfileViewController?
    var queue : OperationQueue?
    
    func newOperation(vc: ProfileViewController, queueQOS: QualityOfService) -> OperationDataManager {
        let dataManager = OperationDataManager()
        dataManager.viewController = vc
        dataManager.queue = self.getOperationQueue(queueQOS)
        return dataManager
    }
    
    func saveData(data: UserData?, success: @escaping () -> (), failure: @escaping () -> ()) {
        self.queue!.addOperation(SaveUserDataOperation(data: data, vc: viewController!))
    }
    
    func retrieveData(setDataFunction: @escaping (UserData?) -> ()) {
        self.queue!.addOperation(RetrieveUserDataOperation(vc: viewController!, completion: setDataFunction))
    }
    
    private func getOperationQueue(_ withQOS: QualityOfService) -> OperationQueue {
        let queue = OperationQueue()
        queue.qualityOfService = withQOS
        return queue
    }
}
