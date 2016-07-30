//
//  ViewController.swift
//  TiltingLoader
//
//  Created by Taylor Franklin on 8/26/14.
//  Copyright (c) 2014 Taylor Franklin. All rights reserved.
//

import UIKit
import QuartzCore

class DemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tiltLoadingView: TiltingLoader!
    @IBOutlet weak var demoTableView: UITableView!
    var titles = ["Fade Dismissal", "Dynamic Dismissal", "Rectangular Shape", "Convenience Method", "Reverse Animation", "Rounded Shape"]
                            
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as UITableViewCell
        cell.textLabel!.text = titles[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let activeLoader = TiltingLoader.activeLoadersInView(self.view)
        
        if (indexPath as NSIndexPath).row == 0 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(x: self.view.frame.size.width/2 - 70, y: self.view.frame.size.height/2 - 70, width: 140, height: 140), color: UIColor.purple(), cornerRad: 0.0)
            tiltLoadingView.enableOverlayOnView(self.view)
            tiltLoadingView.animateColors(false)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
        }
        else if (indexPath as NSIndexPath).row == 1 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(x: self.view.frame.size.width/2 - 70, y: self.view.frame.size.height/2 - 70, width: 140, height: 140), color: UIColor.purple(), cornerRad: 0.0)
            tiltLoadingView.dynamicDismissal = true
            tiltLoadingView.enableOverlayOnView(nil)
            tiltLoadingView.animateColors(false)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
        }
        else if (indexPath as NSIndexPath).row == 2 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(x: 0, y: 224, width: self.view.frame.size.width, height: 80), color: UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0), cornerRad: 0.0)
            tiltLoadingView.dynamicDismissal = true
            tiltLoadingView.enableOverlayOnView(self.view)
            tiltLoadingView.animateColors(false)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
        }
        else if (indexPath as NSIndexPath).row == 3 && !activeLoader {
            TiltingLoader.showTiltingLoader(self.view, color: UIColor.orange(), cornerRad: 0.0)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopLoader), userInfo: nil, repeats: false)
        }
        else if (indexPath as NSIndexPath).row == 4 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(x: self.view.frame.size.width/2 - 70, y: self.view.frame.size.height/2 - 70, width: 140, height: 140), color: UIColor.purple(), cornerRad: 0.0)
            tiltLoadingView.enableOverlayOnView(self.view)
            tiltLoadingView.animateColors(true)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
        }
        else if !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height/2 - 120, width: 240, height: 240), color: UIColor.orange(), cornerRad: 30.0)
            tiltLoadingView.enableOverlayOnView(self.view)
            tiltLoadingView.animateColors(false)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
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

