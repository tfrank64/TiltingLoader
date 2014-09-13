//
//  ViewController.swift
//  TiltingLoader
//
//  Created by Taylor Franklin on 8/26/14.
//  Copyright (c) 2014 Taylor Franklin. All rights reserved.
//

// TODO: add simple examples of different use cases
// TODO: fix tableview sizing
// TODO: finalize Readme

// After open sourcing
// TODO: add bool to determine if loaders already on view

import UIKit

class DemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tiltLoadingView: TiltingLoader!
    @IBOutlet weak var demoTableView: UITableView!
    var titles = ["Fade Dismissal", "Dynamic Dismissal", "Convience Method", "Rectangular Shape", "Circular Shape"]
                            
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = titles[indexPath.row]
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            tiltLoadingView = TiltingLoader(frame: CGRectMake(self.view.frame.size.width/2 - 70, self.view.frame.size.height/2 - 70, 140, 140), color: UIColor.purpleColor())
            tiltLoadingView.dynamicDismissal = false
            self.view.addSubview(tiltLoadingView)
            tiltLoadingView.animateColors(false)
            var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "stopInstance", userInfo: nil, repeats: false)
        }
        else if indexPath.row == 2 {
            TiltingLoader.showTiltingLoader(self.view, color: UIColor.orangeColor())
            var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "stopLoader", userInfo: nil, repeats: false)
        }
    }
    
    func stopInstance() {
        tiltLoadingView.hide()
    }
    
    func stopLoader() {
        TiltingLoader.hideTiltingLoader(self.view, dynamic: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

