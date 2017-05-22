//
//  ImagePickerViewController.swift
//  Tinkoff Chat
//
//  Created by Aliona on 14/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

let SPACING_BETWEEN_CELLS = 10
let CELLS_IN_ROW = 3
let PHOTOS_TO_LOAD = 102 // To fill the whole view

class ImagePickerViewController : UIViewController {
    
    @IBOutlet weak var picCollection: UICollectionView!
    var delegate : ProfileViewController? = nil
    
    @IBAction func cancelButtomPress(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImagePickerViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return PHOTOS_TO_LOAD
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",
                                                      for: indexPath) as! PhotoCell
        if cell.imageLoaded == nil || cell.imageLoaded! == false {
            cell.imageLoaded = false
            self.uploadImageFor(cell: cell, atIndexPath: indexPath)
        }
        
        return cell
    }
    
    private func uploadImageFor(cell: PhotoCell, atIndexPath: IndexPath) {
        DispatchQueue.global(qos: .userInteractive).async {
            RequestSender().send(requestNumber: atIndexPath.row) { (result: Result) in
                DispatchQueue.main.async {
                    switch result {
                    case .Success(let img):
                        cell.imageView.image = img
                        cell.imageLoaded = true
                        break
                    case .Fail(let errorDescription):
                        print ("\(errorDescription)")
                        break
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        if cell.imageLoaded != nil && cell.imageLoaded! {
            var dataToSave = UserData.init()
            dataToSave.image = cell.imageView.image
            GCDDataManager().saveData(data: dataToSave, success: {self.imageSaveSuccess()}, failure: {})
        }
    }
    
    private func imageSaveSuccess() {
        // TODO: Add here update of user image
       // self.delegate?.getSavedData()
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImagePickerViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.size.width - 1 - CGFloat(CELLS_IN_ROW + 1) * CGFloat(SPACING_BETWEEN_CELLS))/CGFloat(CELLS_IN_ROW)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
