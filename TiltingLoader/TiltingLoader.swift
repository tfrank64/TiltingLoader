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
    
    let ratioValue: Float = 12.5
    
    internal var isAnimating: Bool
    internal var layerCount: Int
    internal var sizeDifference: CGFloat
    var layers: [CALayer]
    
    // Recommended frame size of 50 or above
    override init(frame: CGRect) {
        layers = [CALayer]()
        isAnimating = true
        layerCount = 0
        sizeDifference = 0
        super.init(frame: frame)
        
        initView()
        animateColors()
    }
    
    required init(coder aDecoder: NSCoder) {
        layers = [CALayer]()
        isAnimating = true
        layerCount = 0
        sizeDifference = 0
        super.init(coder: aDecoder)
    }
    
    // TODO: make everything customizable by the developer ( color, speed)
    func initView() {
        
        // Calculate number of squares
        var minVal = fmin(self.frame.size.width, self.frame.size.height)
        layerCount = Int(floor(Float(minVal)/ratioValue))
        if (layerCount == 0 || layerCount == 1) { layerCount = 2 } // Effect is pointless with few squares
        println(layerCount)
        println(minVal)
        sizeDifference = minVal/CGFloat(layerCount + 1) // Plus 1 to ensure all layers are visible
        println(sizeDifference)
        
        for index in 0..<layerCount {

            var tempLayer = CALayer()
            if index == 0 {
                tempLayer.frame = CGRectDecrementSize(self.frame, decrement: sizeDifference)
                tempLayer.backgroundColor = UIColor.blueColor().CGColor
                self.layer.addSublayer(tempLayer)
            } else {
                var previousLayer = layers.last as CALayer!
                tempLayer.frame = CGRectDecrementSize(previousLayer.frame, decrement: sizeDifference)
                var previousColor = UIColor(CGColor: previousLayer.backgroundColor)
                tempLayer.backgroundColor = lighterColorForColor(previousColor)
                previousLayer.addSublayer(tempLayer)
            }
            layers.append(tempLayer)
        }
    }
    
    func animateColors() {
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "iterateColors", userInfo: nil, repeats: true)
    }
    
    func iterateColors() {
        
        if isAnimating {
            var tempColor: CGColor = UIColor.whiteColor().CGColor
            for index in 0..<layerCount {
                if index == 0 {
                    tempColor = layers[index].backgroundColor
                    layers[index].backgroundColor = layers[index + 1].backgroundColor
                } else if index == layerCount - 1 {
                    layers[index].backgroundColor = tempColor
                } else {
                    layers[index].backgroundColor = layers[index + 1].backgroundColor
                }
            }
        }
    }
    
    func animateColorsInReverse() {
        
        if isAnimating {
            var tempColor: CGColor = UIColor.whiteColor().CGColor
            for var index = layerCount - 1; index >= 0; index-- {
                if index == layerCount - 1 {
                    tempColor = layers[index].backgroundColor
                    layers[index].backgroundColor = layers[index - 1].backgroundColor
                } else if index == 0 {
                    layers[index].backgroundColor = tempColor
                } else {
                    layers[index].backgroundColor = layers[index - 1].backgroundColor
                }
            }
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
    
    func hide() {
        isAnimating = false
    }

}
