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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blueColor()
        initView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView() {
        var layerOne = CALayer()
        println(self.layer.frame)
        layerOne.frame = CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)
        
        layerOne.backgroundColor = UIColor.redColor().CGColor
        self.layer.addSublayer(layerOne)
        
        var layerTwo = CALayer()
        layerTwo.frame = CGRectMake(5, 5, layerOne.frame.size.width-10, layerOne.frame.size.height-10)
        println(layerTwo.frame)
        layerTwo.backgroundColor = UIColor.greenColor().CGColor
        layerOne.addSublayer(layerTwo)
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
