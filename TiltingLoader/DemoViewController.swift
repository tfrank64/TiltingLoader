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
        cell.textLabel!.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let activeLoader = TiltingLoader.activeLoadersInView(view: self.view)
        
        if indexPath.row == 0 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(self.view.frame.size.width/2 - 70, self.view.frame.size.height/2 - 70, 140, 140), color: UIColor.purple, cornerRad: 0.0)
            tiltLoadingView.enableOverlayOnView(superView: self.view)
            tiltLoadingView.animateColors(reverse: false)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
        }
        else if indexPath.row == 1 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(self.view.frame.size.width/2 - 70, self.view.frame.size.height/2 - 70, 140, 140), color: UIColor.purple, cornerRad: 0.0)
            tiltLoadingView.dynamicDismissal = true
            tiltLoadingView.enableOverlayOnView(superView: nil)
            tiltLoadingView.animateColors(reverse: false)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
        }
        else if indexPath.row == 2 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(0, 224, self.view.frame.size.width, 80), color: UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0), cornerRad: 0.0)
            tiltLoadingView.dynamicDismissal = true
            tiltLoadingView.enableOverlayOnView(superView: self.view)
            tiltLoadingView.animateColors(reverse: false)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
        }
        else if indexPath.row == 3 && !activeLoader {
            TiltingLoader.showTiltingLoader(view: self.view, color: UIColor.orange, cornerRad: 0.0)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopLoader), userInfo: nil, repeats: false)
        }
        else if indexPath.row == 4 && !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(self.view.frame.size.width/2 - 70, self.view.frame.size.height/2 - 70, 140, 140), color: UIColor.purple, cornerRad: 0.0)
            tiltLoadingView.enableOverlayOnView(superView: self.view)
            tiltLoadingView.animateColors(reverse: true)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
        }
        else if !activeLoader {
            tiltLoadingView = TiltingLoader(frame: CGRect(self.view.frame.size.width/2 - 120, self.view.frame.size.height/2 - 120, 240, 240), color: UIColor.orange, cornerRad: 30.0)
            tiltLoadingView.enableOverlayOnView(superView: self.view)
            tiltLoadingView.animateColors(reverse: false)
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DemoViewController.stopInstance), userInfo: nil, repeats: false)
        }
    }
    
    @objc func stopInstance() {
        tiltLoadingView.hide()
        tiltLoadingView = nil
    }
    
    @objc func stopLoader() {
        TiltingLoader.hideTiltingLoader(view: self.view, dynamic: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

