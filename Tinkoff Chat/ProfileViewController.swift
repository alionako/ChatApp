//
//  ProfileViewController.swift
//  Tinkoff Chat
//
//  Created by Aliona on 06/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var about: UITextView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    
    
    private var data : [String: AnyObject] = [:]
    var dataToSave : [String: AnyObject] {
        get {
            return self.data
        }
        set {
            self.data = newValue
            if (newValue.count > 0) {
                self.enableButtons(enable: true)
            }
        }
    }
    
    private var image : UIImage? = nil
    var imageToSave : UIImage? {
        get {
            return self.image
        }
        set {
            self.image = newValue
            if (newValue != nil) {
                self.enableButtons(enable: true)
            }
        }
    }
    
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
        
        self.indicator.stopAnimating()
        self.getSavedData()
        self.enableButtons(enable: false)
    }
    
    func getSavedData() {
        let imgFunction = { image in
            self.userPic.image = image
        }
        let dataFunction : ([String: AnyObject]?) -> () = { data in
            guard data != nil else { return }
            if data?[NAME_KEY] as? String != nil {
                self.name.text = data![NAME_KEY] as? String
            }
            if data?[ABOUT_KEY] as? String != nil {
                self.about.text = data![ABOUT_KEY] as! String
            }
            if data?[COLOR_KEY] as? [Float] != nil {
                let colorSettings = data![COLOR_KEY] as! [Float]
                self.colorLabel.textColor = UIColor.init(colorLiteralRed: colorSettings[0], green: colorSettings[1], blue: colorSettings[2], alpha: colorSettings[3])
            }
        }
        GCDDataManager().retrieveData(setImageFunction: imgFunction, setDataFunction: dataFunction)
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
        dataToSave[NAME_KEY] = textField.text as AnyObject?
        return true;
    }
    
    // MARK - Text view delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.inputAccessoryView = toolBar
        return true
    }
    
    // MARK - Button actions
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.saveData(sender: sender)
    }
    
    internal func saveData(sender: UIButton) {
        let button : UIButton = sender
        let preparationAction = {
            self.indicator.startAnimating()
            self.enableButtons(enable: false)
        }
        let success = {
            self.dataToSave = [:]
            self.imageToSave = nil
            self.enableButtons(enable: false)
            self.indicator.stopAnimating()
            self.showSaveSuccessAlert()
        }
        switch ((button.titleLabel?.text)!) {
        case "GCD":
            let failure = { () in
                self.indicator.stopAnimating()
                self.showSaveFailureAlert(failureHandler: {
                    self.saveButtonAction(sender)
                })
            }
            GCDDataManager().saveData(data: self.data, withImage: self.imageToSave, preparation: preparationAction, success: success, failure: failure)
            break
        case "Operation":
            let failure = { () in
                self.indicator.stopAnimating()
                self.showSaveFailureAlert(failureHandler: {
                    self.saveButtonAction(sender)
                })
            }
            let operationDataManager = OperationDataManager()
            operationDataManager.viewController = self
            operationDataManager.saveData(data: self.data, withImage: self.imageToSave, preparation: preparationAction, success: success, failure: failure)
            break
        default:
            break
        }
        
    }
    
    internal func enableButtons(enable: Bool) {
        self.gcdButton.isEnabled = enable
        self.operationButton.isEnabled = enable
    }
    
    @IBAction func changeLabelColor(_ sender: UIButton) {
        self.colorLabel.textColor = sender.backgroundColor
        dataToSave[COLOR_KEY] = ColorHelper.getColorArray(sender.backgroundColor) as AnyObject?
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
                self.imageToSave = self.userPic.image
            })
            actionSheet.addAction(delete)
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func finishedEditingTextView(_ sender: UIBarButtonItem) {
        dataToSave[ABOUT_KEY] = about.text as AnyObject?
        self.onTapAction()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userPic.image = pickedImage
            imageToSave = pickedImage
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
    
    func showSaveSuccessAlert() {
        let alert = UIAlertController(title: "Данные сохранены", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSaveFailureAlert(failureHandler : @escaping () -> Void) {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: {(alert: UIAlertAction!) in
            failureHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
