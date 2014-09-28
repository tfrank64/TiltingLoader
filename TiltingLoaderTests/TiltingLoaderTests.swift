//
//  TiltingLoaderTests.swift
//  TiltingLoaderTests
//
//  Created by Taylor Franklin on 8/26/14.
//  Copyright (c) 2014 Taylor Franklin. All rights reserved.
//

import UIKit
import XCTest

class TiltingLoaderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        var tiltLoadingView = TiltingLoader(frame: CGRectMake(100, 100, 100, 100), color: UIColor.purpleColor(), cornerRad: 0.0)

        XCTAssertFalse(tiltLoadingView.frame == CGRectZero, "loader frame is zero")
        XCTAssertFalse(!tiltLoadingView.isAnimating, "loader animation is turned off")
        
        tiltLoadingView.isAnimating = false
        XCTAssertEqual(tiltLoadingView.isAnimating, false, "isAnimating is still true")
        
        tiltLoadingView.animationFrequency = 1.0
        XCTAssertEqual(tiltLoadingView.animationFrequency, 1.0, "animationFrequency doesn't equal 1.0")
        
        tiltLoadingView.dynamicDismissal = true
        XCTAssertEqual(tiltLoadingView.dynamicDismissal, true, "dynamicDismissal is not true")
        
        tiltLoadingView.dynamicDismissal = false
        tiltLoadingView.hide()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
