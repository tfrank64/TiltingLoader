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
    private var overlayView: UIView?
    
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
        
        self.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
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
        super.init(coder: aDecoder)!
        self.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
    }
    
    /// Convenience method to always add loader to center of passed in view, not made for customizability, so you cannot add a dark overlay over superview
    ///
    /// - parameter view: view is typically the superview, the view to add the tiltingLoader to
    /// - parameter color: color determines what color the tiltingLoader will be
    class func showTiltingLoader(view: UIView, color: UIColor, cornerRad: CGFloat) {
        let rect = CGRectMake(view.frame.size.width/2 - 50, view.frame.size.height/2 - 50, 100, 100)
        let loader = TiltingLoader(frame: rect, color: color, cornerRad: cornerRad)
        loader.alpha = 0
        view.addSubview(loader)
        view.userInteractionEnabled = false
        loader.animateColors(false)
        UIView.animateWithDuration(0.3, animations: { loader.alpha = 1 })
    }
    
    /// Hides TiltingLoader created with showTiltingLoader
    class func hideTiltingLoader(view: UIView, dynamic: Bool) {
        if let loader = loaderForView(view) {
            loader.dynamicDismissal = dynamic
            loader.hide()
            view.userInteractionEnabled = true
        }
    }
    
    /// Finds TiltingLoader reference
    class func loaderForView(view: UIView) -> TiltingLoader? {
        var tempLoader: TiltingLoader?
        let viewsArray = Array(Array(view.subviews.reverse()))
        for subview in viewsArray {
            if subview.isKindOfClass(self) {
                tempLoader = subview as? TiltingLoader
                break
            }
        }
        return tempLoader!
    }
    
    class func activeLoadersInView(view: UIView) -> Bool {
        let viewsArray = Array(Array(view.subviews.reverse()))
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
        let minVal = fmin(self.frame.size.width, self.frame.size.height)
        viewCount = Int(floor(Float(minVal)/ratioValue))
        if (viewCount == 0 || viewCount == 1) { viewCount = 2 } // Effect is pointless with few squares
        if (viewCount > 10) { viewCount = 10 } // Color gets to white with more than 10
        sizeDifference = minVal/CGFloat(viewCount + 1) // Plus 1 to ensure all views are visible
        let halfSize = sizeDifference/2
        
        // Create squares with increasingly lighter colors
        for index in 0..<viewCount {

            let tempView = UIView()
            if index == 0 {
                tempView.frame = CGRectDecrementSize(self.frame, decrement: sizeDifference)
                tempView.backgroundColor = mainColor
                self.addSubview(tempView)
            } else {
                let previousView = views.last as UIView!
                tempView.frame = CGRectDecrementSize(previousView.frame, decrement: sizeDifference)
                tempView.backgroundColor = lighterColorForColor(previousView.backgroundColor!)
                previousView.addSubview(tempView)
                addHorizontalVerticalMotionToView(halfSize, y: halfSize, view: tempView)
            }
            if cornerRadius > 0 { tempView.layer.cornerRadius = cornerRadius }
            views.append(tempView)
        }
    }
    
    /// Enable overlay behind tilting loader if superview has been passed in
    func enableOverlayOnView(superView: UIView?) {
        
        var alphaValue: CGFloat = 0.0
        if let _ = superView {
            alphaValue = 0.5

        }
        
        self.overlayView = UIView(frame: UIApplication.sharedApplication().keyWindow!.frame)
        self.overlayView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(alphaValue)
        UIApplication.sharedApplication().keyWindow?.addSubview(self.overlayView!)
        self.overlayView!.addSubview(self)
        
    }
    
    /// This method adds vertical and horizontal motion behaviours to a UIView
    ///
    /// - parameter x: x is the horizontal motion range
    /// - parameter y: y is the vertical motion range
    /// - parameter view: view is the UIView for which the motion effect will be applied
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
            let group = UIMotionEffectGroup()
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
    /// - parameter reverse: reverse is a boolean to determine which color iteration method to call
    internal func animateColors(reverse: Bool) {
        if let _ = self.superview {
            animator = UIDynamicAnimator(referenceView: self.superview!)
            
            if reverse {
                NSTimer.scheduledTimerWithTimeInterval(animationFrequency, target: self, selector: #selector(TiltingLoader.iterateColorsInReverse), userInfo: nil, repeats: true)
            } else {
                NSTimer.scheduledTimerWithTimeInterval(animationFrequency, target: self, selector: #selector(TiltingLoader.iterateColors), userInfo: nil, repeats: true)
            }
        } else {
            print("There is no superview for this instance of TiltingLoader", terminator: "")
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
            for index in (viewCount - 1).stride(to: -1, by: -1) {
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
    /// - parameter frame: The frame is the original frame
    /// - parameter decrement: decrement is the scale by which the returned CGRect will be smaller
    /// - returns: Returns a CGRect smaller and centered in frame
    private func CGRectDecrementSize(frame: CGRect, decrement: CGFloat) -> CGRect {
        return CGRectMake(decrement / 2, decrement / 2, frame.size.width - decrement, frame.size.height - decrement)
    }
    
    /// Method that returns a slightly lighter color than the one passed in
    ///
    /// - parameter color: color is the color we want to make ligter
    /// - returns: The lighter color
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

            let gravityBehavior = UIGravityBehavior(items: [self])
            gravityBehavior.gravityDirection = CGVectorMake(0, 7)
            animator!.addBehavior(gravityBehavior)
            
            let itemBehaviour = UIDynamicItemBehavior(items: [self])
            let negate = -M_PI_2
            itemBehaviour.addAngularVelocity(CGFloat(negate), forItem: self)
            animator!.addBehavior(itemBehaviour)
            
            // Give gravity time before removing loader
            NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(TiltingLoader.removeLoader), userInfo: nil, repeats: false)

        } else {
            UIView.animateWithDuration(0.25, animations: {
                self.alpha = 0
            }, completion: {(done: Bool) in
                self.isAnimating = false
                self.removeFromSuperview()
                self.overlayView?.removeFromSuperview()
            })
        }
    }

    func removeLoader() {
        self.removeFromSuperview()
        self.overlayView?.removeFromSuperview()
    }
    
}
