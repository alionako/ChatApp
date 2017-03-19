//
//  ViewController.swift
//  Tinkoff Chat
//
//  Created by Aliona on 06/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var tapCounter = 0
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var userPic: UIImageView!
    
    // MARK - ViewController lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        print(self.view.subviews)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(#function)
        print(self.view.subviews)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(self.onTapAction))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        print(self.view.subviews)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        print(self.view.subviews)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
        print(self.view.subviews)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
        print(self.view.subviews)
    }
    
    // MARK - Hide keyboard
    
    func onTapAction() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onTapAction()
        return true;
    }
    
    // MARK - Text view delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.inputAccessoryView = toolBar
        return true
    }
    
    // MARK - Button actions
    
    @IBAction func saveAction(_ sender: Any) {
        print("Сохранение данных профиля")
    }
    @IBAction func changeLabelColor(_ sender: UIButton) {
        self.colorLabel.textColor = sender.backgroundColor
    }

    @IBAction func selectPicture(_ sender: UITapGestureRecognizer) {
        
        let actionSheet = UIAlertController(title: "Выбрать фото", message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Сделать фото", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.pickPhotosFrom(source: .camera)
        })
        actionSheet.addAction(takePhoto)
        
        let chooseFromLibrary = UIAlertAction(title: "Выбрать из библиотеки", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.pickPhotosFrom(source: .photoLibrary)
        })
        actionSheet.addAction(chooseFromLibrary)
        
        if userPic.image != UIImage.init(named: "UserIconPlaceholder") {
            let delete = UIAlertAction(title: "Удалить", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.userPic.image = UIImage.init(named: "UserIconPlaceholder")
            })
            actionSheet.addAction(delete)
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func finishedEditingTextView(_ sender: UIBarButtonItem) {
        self.onTapAction()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userPic.image = pickedImage
            userPic.contentMode = .scaleAspectFit
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func pickPhotosFrom(source: UIImagePickerControllerSourceType) -> () {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
    }
}

