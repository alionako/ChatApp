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

class ImagePickerViewController : UIViewController {
    @IBOutlet weak var picCollection: UICollectionView!
    
    
    
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
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",
                                                      for: indexPath) as! PhotoCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        var dataToSave = UserData.init()
        dataToSave.image = cell.imageView.image
        GCDDataManager().saveData(data: dataToSave, success: {self.imageSaveSuccess()}, failure: {})
    }
    
    private func imageSaveSuccess() {
        if let controllersCount = navigationController?.viewControllers.count {
            if controllersCount > 1 {
                let profileViewController = navigationController?.viewControllers[controllersCount - 2] as! ProfileViewController
                profileViewController.getSavedData()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImagePickerViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.size.width - 1 - CGFloat(CELLS_IN_ROW + 1) * CGFloat(SPACING_BETWEEN_CELLS))/CGFloat(CELLS_IN_ROW)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
