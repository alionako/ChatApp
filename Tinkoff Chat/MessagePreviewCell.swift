//
//  MessagePreviewCell.swift
//  Tinkoff Chat
//
//  Created by Aliona on 25/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

let FONT_SIZE = 15.0

class MessagePreviewCell : UITableViewCell, ConverstationCellConfiguration {
    
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var messageTextPreview: UILabel!
    @IBOutlet weak var time: UILabel!
    
    private var _name : String? = ""
    private var _message : String? = ""
    private var _date : Date? = nil
    private var _online : Bool = false
    private var _hasUnreadMessages : Bool = true
    
    var name: String? {
        get {
            return _name
        }
        set {
            _name = newValue
            self.chatName.text = _name
        }
    }
    var message: String? {
        get {
            return _message
        }
        set {
            _message = newValue
            if _message == nil || _message?.characters.count == 0 {
                messageTextPreview.text = "No messages yet"
                messageTextPreview.font = UIFont.italicSystemFont(ofSize: CGFloat(FONT_SIZE))
            } else {
                messageTextPreview.text = message
            }
        }
    }
    var date: Date? {
        get {
            return _date
        }
        set {
            _date = newValue
            guard _date != nil else {
                time.text = ""
                return
            }
            let dateComponents = Calendar.current.dateComponents([.day, .month], from: _date!)
            let todayComponents = Calendar.current.dateComponents([.day, .month], from: Date())
            let dateFormatter = DateFormatter()
            if dateComponents == todayComponents {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "dd MMM"
            }
            time.text = dateFormatter.string(from: _date!)
        }
    }
    var online: Bool {
        get {
            return _online
        }
        set {
            _online = newValue
            if _online {
                self.backgroundColor = UIColor.yellow
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    var hasUnreadMessages: Bool {
        get {
            return _hasUnreadMessages
        }
        set {
            _hasUnreadMessages = newValue
            if _hasUnreadMessages {
                messageTextPreview.font = UIFont.boldSystemFont(ofSize: CGFloat(FONT_SIZE))
            }
        }
    }
}
