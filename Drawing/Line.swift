//
//  Line.swift
//  Drawing
//
//  Created by Magnan, Alexandre on 2016-02-12.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class Line:Shape {
    var newY:Double
    var newX:Double
    
    init(X: Double, Y: Double, mOptions: Options, newX: Double, newY: Double) {
        self.newX = newX;
        self.newY = newY
        super.init(X: X, Y: Y, mOptions: mOptions)
    }

    required convenience init?(coder decoder: NSCoder) {
        guard let newX = decoder.decodeObjectForKey("newX") as? Double,
            let newY = decoder.decodeObjectForKey("newY") as? Double,
            let x = decoder.decodeObjectForKey("x") as? Double,
            let y = decoder.decodeObjectForKey("y") as? Double,
            let o = decoder.decodeObjectForKey("o") as? Options
            else { return nil }
        
        self.init (
            X: x,
            Y: y,
            mOptions: o,
            newX: newX,
            newY: newY
        )
    }
    override func touchInShape(location: CGPoint) -> Bool{
        if (CGRectContainsPoint(CGRect(x: X, y: Y, width: newX-X, height: newY-Y), CGPoint(x: location.x, y: location.y))) {
            return true;
        }
        return false
    }
    override func moveShape(newXPoint: Double, newYPoint: Double){
        let oldX = newX - X
        let oldY = newY - Y
        X = newXPoint
        Y = newYPoint
        newX = oldX + X
        newY = oldY + Y
    }
    
    override func drawBorder(context: CGContext) {
    
        let Width = newX - X
        let Height = newY - Y
        
        //We have to calculate the new border according to the width and height if they are negative or not
        var borderX = 0.0
        var borderY = 0.0
        var borderWidth = 0.0
        var borderheight = 0.0
        
        if Width > 0.0 && Height > 0.0 {
            borderX = self.X - 3
            borderY = self.Y - 3
            borderWidth = Width + 6
            borderheight = Height + 6
        }
        else if Width < 0.0 && Height < 0.0 {
            borderX = self.X + 3
            borderY = self.Y + 3
            borderWidth = Width - 6
            borderheight = Height - 6
        }
        else if Width > 0.0 && Height < 0.0 {
            borderX = self.X - 3
            borderY = self.Y + 3
            borderWidth = Width + 6
            borderheight = Height - 6
        }
        else if Width < 0.0 && Height > 0.0 {
            borderX = self.X + 3
            borderY = self.Y - 3
            borderWidth = Width - 6
            borderheight = Height + 6
        }
        
        let rect = CGRect(x: borderX, y: borderY, width: borderWidth, height: borderheight)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var components: [CGFloat] = mOptions.components[0]
        var color = CGColorCreate(colorSpace, components)
        
        CGContextSetLineWidth(context, 1)
        components = mOptions.components[3]
        color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextAddRect(context, rect)
        CGContextStrokePath(context)
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.X, forKey: "x")
        coder.encodeObject(self.Y, forKey: "y")
        coder.encodeObject(self.mOptions, forKey: "o")
        coder.encodeObject(self.newX, forKey: "newX")
        coder.encodeObject(self.newY, forKey: "newY")
    }
    
    override func scale(scale: Double){
        let Width = self.newX - X
        let Height = self.newY - Y
        let scaledWidth = Width * scale
        let scaledHeight = Height * scale
        
        let newX = (Width - scaledWidth)/2
        let newY = (Height - scaledHeight)/2
        self.X = self.X + newX
        self.Y = self.Y + newY
        self.newX = self.X + scaledWidth
        self.newY = self.Y + scaledHeight
        
    }

    override func draw(context: CGContext) {
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var components: [CGFloat] = mOptions.components[0]
        var color = CGColorCreate(colorSpace, components)
        
    
        CGContextSetLineWidth(context, CGFloat(mOptions.LineWidth))
        components = mOptions.components[mOptions.ColorLine]
        color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        
        CGContextMoveToPoint(context, CGFloat(self.X), CGFloat(self.Y))
        CGContextAddLineToPoint(context, CGFloat(self.newX), CGFloat(self.newY))
        CGContextStrokePath(context);
    }
}
