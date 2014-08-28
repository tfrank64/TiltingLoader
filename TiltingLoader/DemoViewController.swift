//
//  ViewController.swift
//  TiltingLoader
//
//  Created by Taylor Franklin on 8/26/14.
//  Copyright (c) 2014 Taylor Franklin. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tiltLoadingView = TiltingLoader(frame: CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100))
        self.view.addSubview(tiltLoadingView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

