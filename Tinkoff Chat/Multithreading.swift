//
//  Multithreading.swift
//  Tinkoff Chat
//
//  Created by Aliona on 04/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

protocol SaveUserDataProtocol {
    
    func saveData(data: [String: AnyObject], withImage: UIImage?, preparation: () -> (), success: @escaping () -> (), failure: @escaping () -> ())
    
    
}

class GCDDataManager: SaveUserDataProtocol {
    func saveData(data: [String: AnyObject], withImage: UIImage?, preparation: () -> (), success: @escaping () -> (), failure: @escaping () -> ()) {
        
        preparation()
                
        DispatchQueue.global(qos: .userInitiated).async {
            FileWriter.writeData(data, image: withImage, success: {
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
    func retrieveData(setImageFunction:@escaping (UIImage) ->(), setDataFunction: @escaping ([String: AnyObject]?) -> ()) {
        
        // Здесь я использовала userInitiated, так как данные должны
        // подгрузиться быстро, в отличие от картинки, таким образом 
        // из более приоритетной очереди мы быстрее их получим
        
        DispatchQueue.global(qos: .userInitiated).async {
            let savedData = FileReader.getData()
            DispatchQueue.main.async {
                setDataFunction(savedData)
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            let savedImage = FileReader.getImage()
            DispatchQueue.main.async {
                setImageFunction(savedImage)
            }
        }
    }
}

class OperationDataManager: SaveUserDataProtocol {
    var viewController : ProfileViewController?
    func saveData(data: [String: AnyObject], withImage: UIImage?, preparation: () -> (), success: @escaping () -> (), failure: @escaping () -> ()) {
    
        preparation()
    
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        operationQueue.addOperation(SaveNewInfo(data: data, image: withImage, vc: viewController!))
    }
}

class SaveNewInfo : Operation {
    
    private var data : [String: AnyObject]?
    private var image : UIImage?
    private var vc: ProfileViewController
    
    init (data: [String: AnyObject]?, image: UIImage?, vc: ProfileViewController) {
        self.data = data
        self.image = image
        self.vc = vc
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let success = {
            self.vc.dataToSave = [:]
            self.vc.imageToSave = nil
            self.vc.enableButtons(enable: false)
            self.vc.indicator.stopAnimating()
            self.vc.showSaveSuccessAlert()
        }
        
        let failure = {
            self.vc.showSaveFailureAlert { (Void) in
                print("OLOLO")
            }
        }
        
        FileWriter.writeData(self.data!, image: self.image, success: success(), failure:  failure())
        
    }
}
