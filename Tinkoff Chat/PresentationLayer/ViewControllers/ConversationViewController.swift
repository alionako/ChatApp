//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Aliona on 26/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ConversationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var dataSource : [String]?
    
    var opponent : String?
    var dataProvider : ChatDataProvider?
    
    var communicator : MultipeerCommunicator? = nil
    var communicationManager : CommunicationManager? = nil
    
    var titleLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 100
        
        self.subscribeForKeyboardNotifications()
        self.subscribeForTextFieldChange()
        
        dataProvider = ChatDataProvider(tableView: table, conversationId: opponent!)
        
        self.dataSource = [" ", "Сообщение номер 2", "Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение"]
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = dataProvider?.fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = dataProvider?.fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageBubbleCell = tableView.dequeueReusableCell(withIdentifier: "MessageBubbleCell") as! MessageBubbleCell
        if let message = dataProvider?.fetchedResultsController.object(at: indexPath) {
            cell.configure(withMessage: message)
        }
        return cell
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func subscribeForTextFieldChange() {
        textField.addTarget(self, action: #selector(onTextChange), for: UIControlEvents.editingChanged)
    }
        
    
    func onTextChange() {
        if textField.text?.characters.count == nil {
            sendButton.isEnabled = false
        } else if textField.text!.characters.count == 1 {
            self.animateButton()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let text = textField.text
        textField.text = nil
        sendButton.isEnabled = false
        self.communicator?.sendMessage(string: text!, to: self.opponent!, completionHandler: { (success, err) in
            if success {
                print("Success!")
            } else if let error = err {
                print("ERROR: \(error)")
            } else {
                print ("No success this time :(")
            }
//            Message.saveMessage(userId: String, text: <#T##String#>, sentByAppUser: <#T##Bool#>, completion: Void)
            Message.saveMessage(userId: self.opponent!, text: text!, sentByAppUser: true, completion: {
                self.dataProvider?.fetchResults()
            }())
        })
    }
    
    // MARK - Animation
    func animateButton() {
        UIView.transition(with: sendButton,
                                  duration: 0.5,
                                  options: .curveEaseInOut,
                                  animations: {
                                    self.sendButton.isEnabled = true
                                    self.sendButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                                    },
                                  completion: { Void in
                                    self.sendButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                    })
    }
    
    func animateTitle(connected: Bool) {
        if titleLabel == nil {
            let title = self.navigationItem.title
            titleLabel = UILabel()
            titleLabel?.text = title
            titleLabel?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height:100)
            self.navigationItem.titleView = titleLabel
        }
        if connected == true {
            self.titleAnimation(color: UIColor.green, scale: 1.1, options: .curveEaseIn)
        } else {
            self.titleAnimation(color: UIColor.black, scale: 1.0, options: .curveEaseOut)
        }
    }
    
    func titleAnimation(color : UIColor, scale: CGFloat, options: UIViewAnimationOptions) {
        UIView.transition(with: self.titleLabel!,
                          duration: 1.0,
                          options: options,
                          animations: {
                            self.titleLabel?.textColor = color
                            self.titleLabel?.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        LogoEmitter.emitLogos(self.view, recognizer: sender)
    }
    
    // MARK - Keyboard stuff
    private func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardSize : CGRect = (notification.userInfo! as NSDictionary).object(forKey: UIKeyboardFrameBeginUserInfoKey as AnyObject) as! CGRect
        bottomConstraint.constant = keyboardSize.size.height
        view.layoutIfNeeded()
        self.scrollToBottom()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        view.layoutIfNeeded()
        self.scrollToBottom()
    }
    
    private func scrollToBottom() {
        let lastRowIndex = table.numberOfRows(inSection: 0) - 1
        if lastRowIndex >= 0 {
            let indexPath = IndexPath(row: lastRowIndex, section: 0)
            table.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
}
