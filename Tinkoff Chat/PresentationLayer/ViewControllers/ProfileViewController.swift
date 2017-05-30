//
//  ProfileViewController.swift
//  Tinkoff Chat
//
//  Created by Aliona on 06/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var about: UITextView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    
    
    private var data : UserData? = UserData.init()
    var dataToSave : UserData? {
        get {
            return self.data
        }
        set {
            self.data = newValue
            if newValue != nil {
                self.enableButtons(enable: true)
            }
        }
    }
    
    lazy var operationDataManager: OperationDataManager = self.initOperationDataManager()
    
    func initOperationDataManager() -> OperationDataManager {
        return OperationDataManager().newOperation(vc: self, queueQOS: .userInitiated)
    }

    // MARK - ViewController lifecycle
    
    override func viewDidLoad()  {
        
        super.viewDidLoad()
        
        self.indicator.stopAnimating()
        self.enableButtons(enable: false)
        self.getSavedData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(self.onTapAction))
        view.addGestureRecognizer(tapGesture)
    }
    
    func getSavedData() {
        self.operationDataManager.retrieveData(setDataFunction: { data in
            guard data != nil else { return }
            if data?.name != nil {
                self.name.text = data?.name
            }
            if data?.about != nil {
                self.about.text = data?.about
            }
            if data?.color != nil {
                let color = data!.color!
                self.colorLabel.textColor = ColorHelper.getColorFromStruct(color)
            }
            if data?.image != nil {
                self.userPic.image = data?.image
            }
        })
    }
    
    // MARK - Hide keyboard
    
    func onTapAction() {
        view.endEditing(true)
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
            self.dataToSave = UserData.init()
            self.enableButtons(enable: false)
            self.indicator.stopAnimating()
            self.showSaveSuccessAlert()
        }
        switch ((button.titleLabel?.text)!) {
        case "GCD":
            preparationAction()
            let failure = { () in
                self.indicator.stopAnimating()
                self.showSaveFailureAlert(failureHandler: {
                    self.saveButtonAction(sender)
                })
            }
            GCDDataManager().saveData(data: self.data, success: success, failure: failure)
            break
        case "Operation":
            preparationAction()
            let failure = { () in
                self.indicator.stopAnimating()
                self.showSaveFailureAlert(failureHandler: {
                    self.saveButtonAction(sender)
                })
            }
            self.operationDataManager.saveData(data: self.data, success: success, failure: failure)
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
        dataToSave?.color = ColorHelper.getColorStruct(sender.backgroundColor)
    }
    
    @IBAction func selectPicture(_ sender: UITapGestureRecognizer) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
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
        
        let loadImage = UIAlertAction(title: "Загрузить", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showPhotosController()
        })
        actionSheet.addAction(loadImage)
        
        if userPic.image != UIImage.init(named: "UserIconPlaceholder") {
            let delete = UIAlertAction(title: "Удалить", style: .destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                self.userPic.image = UIImage.init(named: "UserIconPlaceholder")
                self.dataToSave?.image = self.userPic.image
            })
            actionSheet.addAction(delete)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func finishedEditingTextView(_ sender: UIBarButtonItem) {
        dataToSave?.about = about.text
        self.onTapAction()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userPic.image = pickedImage
            dataToSave?.image = pickedImage
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
    
    private func showPhotosController() {
        let storyboard = UIStoryboard(name: "ImagePicker", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController()
        let controller = navigationController?.childViewControllers[0] as! ImagePickerViewController
        controller.delegate = self
        self.present(navigationController!, animated: true, completion: nil)
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

extension ProfileViewController : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.inputAccessoryView = toolBar
        return true
    }
}

extension ProfileViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onTapAction()
        dataToSave?.name = textField.text
        return true;
    }
}
