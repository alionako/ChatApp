//
//  ColorHelper.swift
//  Tinkoff Chat
//
//  Created by Aliona on 04/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class ColorHelper {
    class func getColorArray(_ color: UIColor?) -> [CGFloat]? {
        
        if (color == nil) {
            return nil
        }
        
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var alpha: CGFloat = 0
        if (color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha))! {
            return [red, green, blue, alpha]
        } else {
            return nil
        }
    }
}
