//
//  LogoEmitter.swift
//  Tinkoff Chat
//
//  Created by Aliona on 27/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class LogoEmitter {
    static func emitLogos(_ view: UIView, recognizer: UITapGestureRecognizer) {
        
        LogoEmitter.removeEmitterLayer(view)
        
        let tapPoint : CGPoint = recognizer.location(in: view)
        let emitterLayer = CAEmitterLayer()
        
        emitterLayer.emitterPosition = CGPoint(x: tapPoint.x, y: tapPoint.y)
        
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 5
        cell.velocity = 50
        cell.scale = 0.05
        
        cell.emissionRange = 10
        cell.contents = UIImage(named: "Logo.png")!.cgImage
        
        emitterLayer.emitterCells = [cell]
        
        view.layer.addSublayer(emitterLayer)
    }
    
    private static func removeEmitterLayer(_ view: UIView) {
        if let subLayers = view.layer.sublayers {
            for subLayer in subLayers {
                if subLayer.isKind(of: CAEmitterLayer.classForCoder()) {
                    subLayer.removeFromSuperlayer()
                }
            }
        }
    }
}
