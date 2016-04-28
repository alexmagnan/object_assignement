//
//  Shape.swift
//  Drawing
//
//  Created by Chris Chadillon on 2016-02-10.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class Shape: NSObject, NSCoding{
    var X:Double
    var Y:Double
    let mOptions:Options
    override
    init(){
        self.X = 0
        self.Y = 0
        self.mOptions=Options()
    }
    init(X:Double, Y:Double, mOptions:Options) {
        self.X = X
        self.Y = Y
        self.mOptions=Options(LineWidth: mOptions.LineWidth,FillLine: mOptions.FillLine,ColorLine: mOptions.ColorLine,ColorFill: mOptions.ColorFill)
    }
    
    func draw (contect: CGContext){}
    
    func touchInShape(location: CGPoint)-> Bool{return false}
    
    func scale(scale: Double){}
    
    func moveShape(newXPoint: Double, newYPoint: Double){
        X = newXPoint
        Y = newYPoint
    }
    
    func drawBorder(context: CGContext){}
    required convenience init?(coder decoder: NSCoder) {
        guard let x = decoder.decodeObjectForKey("x") as? Double,
            let y = decoder.decodeObjectForKey("y") as? Double,
            let o = decoder.decodeObjectForKey("o") as? Options
            else { return nil }
        
        self.init(
            X: x,
            Y: y,
            mOptions: o
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.X, forKey: "x")
        coder.encodeObject(self.Y, forKey: "y")
        coder.encodeObject(self.mOptions, forKey: "o")
    }
}
