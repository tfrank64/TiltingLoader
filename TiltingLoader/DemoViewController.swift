//
//  ViewController.swift
//  TiltingLoader
//
//  Created by Taylor Franklin on 8/26/14.
//  Copyright (c) 2014 Taylor Franklin. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    
    var tiltLoadingView: TiltingLoader!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tiltLoadingView = TiltingLoader(frame: CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 90, 90), color: UIColor.orangeColor())
        self.view.addSubview(tiltLoadingView)
        tiltLoadingView.animateColors()
        //var timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "stop", userInfo: nil, repeats: false)
    }
    
    func stop() {
        tiltLoadingView.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

