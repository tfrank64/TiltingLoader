//
//  CG+Extension.swift
//  TiltingLoader
//
//  Created by Sudhanshu Raheja on 26/10/17.
//  Copyright © 2017 Taylor Franklin. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}
