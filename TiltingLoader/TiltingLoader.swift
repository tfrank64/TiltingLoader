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
    
    private let ratioValue: Float = 12.5
    private let colorShadeDifference: CGFloat = 0.05
    private var animator: UIDynamicAnimator?
    
    internal var isAnimating: Bool
    internal var animationFrequency: NSTimeInterval
    internal var mainColor: UIColor
    internal var dynamicDismissal: Bool {
        get {
            return animator == nil ? false : true
        }
        set(val) {
            if val {
                animator = UIDynamicAnimator(referenceView: self.superview)
            }
        }
    }
    
    private var viewCount: Int
    private var sizeDifference: CGFloat
    private var views: [UIView]
    
    // Recommended frame size of 50 or above
    init(frame: CGRect, color: UIColor) {
        isAnimating = true
        animationFrequency = 0.7
        mainColor = color
        
        viewCount = 0
        sizeDifference = 0
        views = [UIView]()
        super.init(frame: frame)
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        initView()
    }
    
    required init(coder aDecoder: NSCoder) {
        isAnimating = true
        animationFrequency = 0.7
        mainColor = UIColor.purpleColor()
        
        viewCount = 0
        sizeDifference = 0
        views = [UIView]()
        super.init(coder: aDecoder)
        self.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
    }
    // TODO: add method and var documentation
    // TODO: add convenience init that centers loading view in passed in view
    private func initView() {
        //animator = UIDynamicAnimator(referenceView: self.superview)
        // Calculate number of squares
        var minVal = fmin(self.frame.size.width, self.frame.size.height)
        viewCount = Int(floor(Float(minVal)/ratioValue))
        if (viewCount == 0 || viewCount == 1) { viewCount = 2 } // Effect is pointless with few squares
        if (viewCount > 10) { viewCount = 10 } // Color gets to white with more than 10
        sizeDifference = minVal/CGFloat(viewCount + 1) // Plus 1 to ensure all views are visible
        var halfSize = sizeDifference/2
        
        // Create squares with increasingly lighter colors
        for index in 0..<viewCount {

            var tempView = UIView()
            if index == 0 {
                tempView.frame = CGRectDecrementSize(self.frame, decrement: sizeDifference)
                tempView.backgroundColor = mainColor
                self.addSubview(tempView)
            } else {
                var previousView = views.last as UIView!
                tempView.frame = CGRectDecrementSize(previousView.frame, decrement: sizeDifference)
                tempView.backgroundColor = lighterColorForColor(previousView.backgroundColor!)
                previousView.addSubview(tempView)
                addHorizontalVerticalMotionToView(halfSize, y: halfSize, view: tempView)
            }
            views.append(tempView)
        }
    }
    
    // Method adapted from http://useyourloaf.com/blog/2014/01/03/motion-effects.html
    private func addHorizontalVerticalMotionToView(x: CGFloat, y: CGFloat, view: UIView) {
        var xAxis: UIInterpolatingMotionEffect?
        var yAxis: UIInterpolatingMotionEffect?
        
        if x != 0.0 {
            xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
            xAxis!.minimumRelativeValue = -x
            xAxis!.maximumRelativeValue = x
        }
        if y != 0.0 {
            yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
            yAxis!.minimumRelativeValue = -y
            yAxis!.maximumRelativeValue = y
        }
        
        if xAxis != nil || yAxis != nil {
            var group = UIMotionEffectGroup()
            var effects = [UIInterpolatingMotionEffect]()
            if let val = xAxis {
                effects.append(val)
            }
            if let val = yAxis {
                effects.append(val)
            }
            group.motionEffects = effects
            view.addMotionEffect(group)
        }
    }
    
    internal func animateColors(reverse: Bool) {
        if reverse {
            var timer = NSTimer.scheduledTimerWithTimeInterval(animationFrequency, target: self, selector: "iterateColorsInReverse", userInfo: nil, repeats: true)
        } else {
            var timer = NSTimer.scheduledTimerWithTimeInterval(animationFrequency, target: self, selector: "iterateColors", userInfo: nil, repeats: true)
        }
    }
    
    internal func iterateColors() {
        
        if isAnimating {
            var tempColor: UIColor = UIColor.whiteColor()
            for index in 0..<viewCount {
                if index == 0 {
                    tempColor = views[index].backgroundColor!
                    views[index].backgroundColor = views[index + 1].backgroundColor
                } else if index == viewCount - 1 {
                    views[index].backgroundColor = tempColor
                } else {
                    views[index].backgroundColor = views[index + 1].backgroundColor
                }
            }
        }
    }
    
    internal func iterateColorsInReverse() {
        
        if isAnimating {
            var tempColor: UIColor = UIColor.whiteColor()
            for var index = viewCount - 1; index >= 0; index-- {
                if index == viewCount - 1 {
                    tempColor = views[index].backgroundColor!
                    views[index].backgroundColor = views[index - 1].backgroundColor
                } else if index == 0 {
                    views[index].backgroundColor = tempColor
                } else {
                    views[index].backgroundColor = views[index - 1].backgroundColor
                }
            }
        }
    }
    
    private func CGRectDecrementSize(frame: CGRect, decrement: CGFloat) -> CGRect {
        return CGRectMake(decrement / 2, decrement / 2, frame.size.width - decrement, frame.size.height - decrement)
    }
    
    private func lighterColorForColor(color: UIColor) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a: CGFloat = 0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + colorShadeDifference, 1.0), green: min(g + colorShadeDifference, 1.0), blue: min(b + colorShadeDifference, 1.0), alpha: a)
        }
        return color
    }
    
    internal func hide() {
        if dynamicDismissal {
            self.isAnimating = false

            var gravityBehavior = UIGravityBehavior(items: [self])
            gravityBehavior.gravityDirection = CGVectorMake(0, 7)
            animator!.addBehavior(gravityBehavior)
            
            var itemBehaviour = UIDynamicItemBehavior(items: [self])
            var negate = -M_PI_2
            itemBehaviour.addAngularVelocity(CGFloat(negate), forItem: self)
            animator!.addBehavior(itemBehaviour)
            
            // Give gravity time before removing loader
            NSTimer(timeInterval: 1.0, target: self, selector: "removeLoader", userInfo: nil, repeats: false)
            
        } else {
            UIView.animateWithDuration(0.25, animations: {
                self.alpha = 0
            }, completion: {(done: Bool) in
                self.isAnimating = false
                self.removeFromSuperview()
            })
        }
    }

    func removeLoader() {
        self.removeFromSuperview()
    }
    
}
