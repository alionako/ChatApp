//
//  ColorHelper.swift
//  Tinkoff Chat
//
//  Created by Aliona on 04/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

struct LabelColor {
    let red : CGFloat
    let green : CGFloat
    let blue : CGFloat
    let alpha : CGFloat
}

protocol ColorHelperProtocol {
    static func getColorStruct(_ color: UIColor?) -> LabelColor?
    static func getColorFromStruct(_ colorStruct : LabelColor) -> UIColor
    static func getColorStructFromArray(_ array: [CGFloat]) -> LabelColor?
    static func getColorArrayFromStruct(_ colorStruct: LabelColor?) -> [CGFloat]?
}

class ColorHelper : ColorHelperProtocol {
    static func getColorStruct(_ color: UIColor?) -> LabelColor? {
        
        if (color == nil) {
            return nil
        }
        
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var alpha: CGFloat = 0
        if (color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha))! {
            return LabelColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
    
    static func getColorFromStruct(_ colorStruct : LabelColor) -> UIColor {
        return UIColor.init(red: CGFloat(colorStruct.red),
                       green: CGFloat(colorStruct.green),
                       blue: CGFloat(colorStruct.blue),
                       alpha: CGFloat(colorStruct.alpha))
    }
    
    static func getColorStructFromArray(_ array: [CGFloat]) -> LabelColor? {
        guard array.count > 3 else { return nil }
        return LabelColor(red: array[0], green: array[1], blue: array[2], alpha: array[3])
    }
    
    static func getColorArrayFromStruct(_ colorStruct: LabelColor?) -> [CGFloat]? {
        if colorStruct == nil { return nil }
        return [colorStruct!.red, colorStruct!.green, colorStruct!.blue, colorStruct!.alpha]
    }
}
