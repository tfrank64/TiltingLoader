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
    
    /// Determines if loader is or should be animating
    internal var isAnimating: Bool
    
    /// The interval for how often to swap colors in the loader
    internal var animationFrequency: NSTimeInterval
    
    /// Value to determine how the loader will be dismissed
    internal var dynamicDismissal: Bool
    
    /// The base color for the loader
    private var mainColor: UIColor
    /// Determines if corners should be rounded
    private var cornerRadius: CGFloat
    private var viewCount: Int
    private var sizeDifference: CGFloat
    private var views: [UIView]
    
    /// Tip: Recommended frame size of 50 or above
    init(frame: CGRect, color: UIColor, cornerRad: CGFloat) {
        isAnimating = true
        animationFrequency = 0.7
        mainColor = color
        dynamicDismissal = false;
        cornerRadius = cornerRad
        
        viewCount = 0
        sizeDifference = 0
        views = [UIView]()
        super.init(frame: frame)
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        initView()
    }
    
    /// NSCoder init seems to be mandatory for a UIView subclass in Swift
    required init(coder aDecoder: NSCoder) {
        isAnimating = true
        animationFrequency = 0.7
        mainColor = UIColor.purpleColor()
        dynamicDismissal = false;
        cornerRadius = 0.0
        
        viewCount = 0
        sizeDifference = 0
        views = [UIView]()
        super.init(coder: aDecoder)
        self.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
    }
    
    /// Convenience method to always add loader to center of passed in view
    ///
    /// :param: view view is typically the superview, the view to add the tiltingLoader to
    /// :param: color color determines what color the tiltingLoader will be
    class func showTiltingLoader(view: UIView, color: UIColor, cornerRad: CGFloat) {
        var rect = CGRectMake(view.frame.size.width/2 - 50, view.frame.size.height/2 - 50, 100, 100)
        var loader = TiltingLoader(frame: rect, color: color, cornerRad: cornerRad)
        loader.alpha = 0
        view.addSubview(loader)
        loader.animateColors(false)
        UIView.animateWithDuration(0.3, animations: { loader.alpha = 1 })
    }
    
    /// Hides TiltingLoader created with showTiltingLoader
    class func hideTiltingLoader(view: UIView, dynamic: Bool) {
        if let loader = loaderForView(view) {
            loader.dynamicDismissal = dynamic
            loader.hide()
        }
    }
    
    /// Finds TiltingLoader reference
    class func loaderForView(view: UIView) -> TiltingLoader? {
        var tempLoader: TiltingLoader?
        var viewsArray = view.subviews.reverse()
        for subview in viewsArray {
            if subview.isKindOfClass(self) {
                tempLoader = subview as? TiltingLoader
                break
            }
        }
        return tempLoader!
    }
    
    class func activeLoadersInView(view: UIView) -> Bool {
        var viewsArray = view.subviews.reverse()
        for subview in viewsArray {
            if subview.isKindOfClass(self) {
                return true
            }
        }
        return false
    }
    
    /// Creates all the main UI components
    private func initView() {
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
            if cornerRadius > 0 { tempView.layer.cornerRadius = cornerRadius }
            views.append(tempView)
        }
    }
    
    /// This method adds vertical and horizontal motion behaviours to a UIView
    ///
    /// :param: x x is the horizontal motion range
    /// :param: y y is the vertical motion range
    /// :param: view view is the UIView for which the motion effect will be applied
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
        // Method adapted from http://useyourloaf.com/blog/2014/01/03/motion-effects.html
    }
    
    /// Begins color animation process by determining which color iteration method to call
    ///
    /// :param: reverse reverse is a boolean to determine which color iteration method to call
    internal func animateColors(reverse: Bool) {
        animator = UIDynamicAnimator(referenceView: self.superview!)
        
        if reverse {
            var timer = NSTimer.scheduledTimerWithTimeInterval(animationFrequency, target: self, selector: "iterateColorsInReverse", userInfo: nil, repeats: true)
        } else {
            var timer = NSTimer.scheduledTimerWithTimeInterval(animationFrequency, target: self, selector: "iterateColors", userInfo: nil, repeats: true)
        }
    }
    
    /// iterateColors() swaps the background colors of views for an animation effect
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
    
    /// iterateColorsInReverse() swaps the background colors of views for an animation effect
    /// It is different from iterateColors() in that it does it in the opposite order
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
    
    /// Helper method to make a CGRect the decrement size smaller
    ///
    /// :param: frame The frame is the original frame
    /// :param: decrement decrement is the scale by which the returned CGRect will be smaller
    /// :returns: Returns a CGRect smaller and centered in frame
    private func CGRectDecrementSize(frame: CGRect, decrement: CGFloat) -> CGRect {
        return CGRectMake(decrement / 2, decrement / 2, frame.size.width - decrement, frame.size.height - decrement)
    }
    
    /// Method that returns a slightly lighter color than the one passed in
    ///
    /// :param: color color is the color we want to make ligter
    /// :returns: The lighter color
    private func lighterColorForColor(color: UIColor) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a: CGFloat = 0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + colorShadeDifference, 1.0), green: min(g + colorShadeDifference, 1.0), blue: min(b + colorShadeDifference, 1.0), alpha: a)
        }
        return color
    }
    
    /// Dismisses TiltingLoader with a gravit drop or a fade
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
            NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: "removeLoader", userInfo: nil, repeats: false)

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
