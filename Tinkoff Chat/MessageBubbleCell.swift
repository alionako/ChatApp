//
//  MessageBubbleCell.swift
//  Tinkoff Chat
//
//  Created by Aliona on 27/03/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class MessageBubbleCell : UITableViewCell, MessageCellCofiguration {
    
    @IBOutlet weak var bubble: UIView!
    @IBOutlet weak var label: UILabel!
    
    private var _text : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bubble.layer.cornerRadius = 10
    }
    
    var txt : String? {
        get {
            return _text
        }
        set {
            _text = newValue
            label.text = txt
        }
    }

}
