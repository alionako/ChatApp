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
    @IBOutlet weak var table: UITableView!
    
    var dataSource : [String]?
    var frame : CGRect?
    
    var titleLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 100
        
        frame = self.view.frame
        self.navigationItem.backBarButtonItem?.title = ""
        
        self.dataSource = [" ", "Сообщение номер 2", "Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение Очень длинное сообщение"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            self.animateButton()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataSource?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageBubbleCell = tableView.dequeueReusableCell(withIdentifier: "MessageBubbleCell") as! MessageBubbleCell
        cell.txt = dataSource?[indexPath.row]
        return cell
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 300)

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.frame = frame!
        textField.resignFirstResponder()
        return true
    }
    
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
    
    func animateTitle() {
        if titleLabel == nil {
            let title = self.navigationItem.title
            titleLabel = UILabel()
            titleLabel?.text = title
            titleLabel?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height:100)
            self.navigationItem.titleView = titleLabel
        }
        if titleLabel?.textColor == UIColor.green {
            self.titleAnimation(color: UIColor.black, scale: 1.0, options: .curveEaseOut)
        } else {
            self.titleAnimation(color: UIColor.green, scale: 1.1, options: .curveEaseIn)
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
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        self.animateTitle()
        LogoEmitter.emitLogos(self.view, recognizer: sender)
    }
}
