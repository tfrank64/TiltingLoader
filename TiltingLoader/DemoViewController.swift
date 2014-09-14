//
//  ViewController.swift
//  TiltingLoader
//
//  Created by Taylor Franklin on 8/26/14.
//  Copyright (c) 2014 Taylor Franklin. All rights reserved.
//

// TODO: finalize Readme

import UIKit
import QuartzCore

class DemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tiltLoadingView: TiltingLoader!
    @IBOutlet weak var demoTableView: UITableView!
    var titles = ["Fade Dismissal", "Dynamic Dismissal", "Rectangular Shape", "Convience Method", "Reverse Animation", "Rounded Shape"]
                            
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var activeLoader = TiltingLoader.activeLoadersInView(self.view)
        
        if indexPath.row == 0 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRectMake(self.view.frame.size.width/2 - 70, self.view.frame.size.height/2 - 70, 140, 140), color: UIColor.purpleColor(), cornerRad: 0.0)
            self.view.addSubview(tiltLoadingView)
            tiltLoadingView.animateColors(false)
            var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "stopInstance", userInfo: nil, repeats: false)
        }
        else if indexPath.row == 1 && !activeLoader{
            tiltLoadingView = TiltingLoader(frame: CGRectMake(self.view.frame.size.width/2 - 70, self.view.frame.size.height/2 - 70, 140, 140), color: UIColor.purpleColor(), cornerRad: 0.0)
            tiltLoadingView.dynamicDismissal = true
            self.view.addSubview(tiltLoadingView)
            tiltLoadingView.animateColors(false)
            var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "stopInstance", userInfo: nil, repeats: false)
        }
        else if indexPath.row == 2 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRectMake(0, 224, self.view.frame.size.width, 80), color: UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0), cornerRad: 0.0)
            tiltLoadingView.dynamicDismissal = true
            self.view.addSubview(tiltLoadingView)
            tiltLoadingView.animateColors(false)
            var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "stopInstance", userInfo: nil, repeats: false)
        }
        else if indexPath.row == 3 && !activeLoader {
            TiltingLoader.showTiltingLoader(self.view, color: UIColor.orangeColor(), cornerVal: 0.0)
            var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "stopLoader", userInfo: nil, repeats: false)
        }
        else if indexPath.row == 4 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRectMake(self.view.frame.size.width/2 - 70, self.view.frame.size.height/2 - 70, 140, 140), color: UIColor.purpleColor(), cornerRad: 0.0)
            self.view.addSubview(tiltLoadingView)
            tiltLoadingView.animateColors(true)
            var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "stopInstance", userInfo: nil, repeats: false)
        }
        else if !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRectMake(self.view.frame.size.width/2 - 120, self.view.frame.size.height/2 - 120, 240, 240), color: UIColor.orangeColor(), cornerRad: 30.0)
            self.view.addSubview(tiltLoadingView)
            tiltLoadingView.animateColors(false)
            var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "stopInstance", userInfo: nil, repeats: false)
        }
    }
    
    func stopInstance() {
        tiltLoadingView.hide()
        tiltLoadingView = nil
    }
    
    func stopLoader() {
        TiltingLoader.hideTiltingLoader(self.view, dynamic: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

