//
//  TiltingLoader.swift
//  TiltingLoader
//
//  Created by Taylor Franklin on 8/26/14.
//  Copyright (c) 2014 Taylor Franklin. All rights reserved.
//

import UIKit
import QuartzCore

class TiltingLoader: UIView {
    
    var layers: [CALayer]
    
    override init(frame: CGRect) {
        layers = [CALayer]()
        super.init(frame: frame)
        
        //self.backgroundColor = UIColor.blueColor()
        initView()
    }
    
    required init(coder aDecoder: NSCoder) {
        layers = [CALayer]()
        super.init(coder: aDecoder)
    }
    
    func initView() {
        
        for index in 1...10 {
            
            var tempLayer = CALayer()
            if index == 1 {
                tempLayer.frame = CGRectDecrementSize(self.frame, decrement: 10)
                tempLayer.backgroundColor = UIColor.blackColor().CGColor
                self.layer.addSublayer(tempLayer)
            } else {
                var previousLayer = layers.last as CALayer!
                tempLayer.frame = CGRectDecrementSize(previousLayer.frame, decrement: 10)
                var previousColor = UIColor(CGColor: previousLayer.backgroundColor)
                tempLayer.backgroundColor = lighterColorForColor(previousColor)
                previousLayer.addSublayer(tempLayer)
            }
            println(index)
            layers.append(tempLayer)
        }
    }
    
    func CGRectDecrementSize(frame: CGRect, decrement: CGFloat) -> CGRect {
        return CGRectMake(decrement / 2, decrement / 2, frame.size.width - decrement, frame.size.height - decrement)
    }
    
    let decreaseValue: CGFloat = 0.1
    
    func lighterColorForColor(color: UIColor) -> CGColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a: CGFloat = 0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            var stuff = min(r + decreaseValue, 1.0)
            return UIColor(red: min(r + decreaseValue, 1.0), green: min(g + decreaseValue, 1.0), blue: min(b + decreaseValue, 1.0), alpha: a).CGColor
        }
        return color.CGColor
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
