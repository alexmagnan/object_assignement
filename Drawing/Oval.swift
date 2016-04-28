//
//  Oval.swift
//  Drawing
//
//  Created by Chris Chadillon on 2016-02-10.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class Oval:Shape{
    var Height:Double
    var Width:Double
    
    init(X: Double, Y: Double,mOptions: Options, Height: Double, Width: Double) {
        self.Height = Height
        self.Width = Width
        super.init(X: X, Y: Y,mOptions: mOptions)
    }
    
    override func draw(context: CGContext) {
        let rect = CGRect(x: self.X, y: self.Y, width: self.Width, height: self.Height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var components: [CGFloat] = mOptions.components[0]
        var color = CGColorCreate(colorSpace, components)
        
        if mOptions.FillLine{
            components = mOptions.components[mOptions.ColorFill]
            color = CGColorCreate(colorSpace, components)
            CGContextSetFillColorWithColor(context, color)
            CGContextAddEllipseInRect(context, rect)
            CGContextFillPath(context)
        }
        CGContextSetLineWidth(context, CGFloat(mOptions.LineWidth))
        components = mOptions.components[mOptions.ColorLine]
        color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextAddEllipseInRect(context, rect)
        CGContextStrokePath(context)
    }
    override func drawBorder(context: CGContext) {
        //We have to calculate the new border according to the width and height if they are negative or not
        var borderX = 0.0
        var borderY = 0.0
        var borderWidth = 0.0
        var borderheight = 0.0
        
        if self.Width > 0.0 && self.Height > 0.0 {
            borderX = self.X - 3
            borderY = self.Y - 3
            borderWidth = self.Width + 6
            borderheight = self.Height + 6
        }
        else if self.Width < 0.0 && self.Height < 0.0 {
            borderX = self.X + 3
            borderY = self.Y + 3
            borderWidth = self.Width - 6
            borderheight = self.Height - 6
        }
        else if self.Width > 0.0 && self.Height < 0.0 {
            borderX = self.X - 3
            borderY = self.Y + 3
            borderWidth = self.Width + 6
            borderheight = self.Height - 6
        }
        else if self.Width < 0.0 && self.Height > 0.0 {
            borderX = self.X + 3
            borderY = self.Y - 3
            borderWidth = self.Width - 6
            borderheight = self.Height + 6
        }
        
        let rect = CGRect(x: borderX, y: borderY, width: borderWidth, height: borderheight)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var components: [CGFloat] = mOptions.components[0]
        var color = CGColorCreate(colorSpace, components)
        
        CGContextSetLineWidth(context, 1)
        components = mOptions.components[3]
        color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextAddEllipseInRect(context, rect)
        CGContextStrokePath(context)
    }
    override func touchInShape(location: CGPoint) -> Bool{
        if (CGRectContainsPoint(CGRect(x: X, y: Y, width: Width, height: Height), CGPoint(x: location.x, y: location.y))) {
            return true;
        }
        return false
    }
    
    override func scale(scale: Double){
        let scaledWidth = self.Width * scale
        let scaledHeight = self.Height * scale
        
        let newX = (self.Width - scaledWidth)/2
        let newY = (self.Height - scaledHeight)/2
        self.X = self.X + newX
        self.Y = self.Y + newY
        self.Width = scaledWidth
        self.Height = scaledHeight
        
    }

    required convenience init?(coder decoder: NSCoder) {
        guard let width = decoder.decodeObjectForKey("width") as? Double,
            let height = decoder.decodeObjectForKey("height") as? Double,
            let x = decoder.decodeObjectForKey("x") as? Double,
            let y = decoder.decodeObjectForKey("y") as? Double,
            let o = decoder.decodeObjectForKey("o") as? Options
            else { return nil }
        
        self.init (
            X: x,
            Y: y,
            mOptions: o,
            Height: height,
            Width: width
        )
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.X, forKey: "x")
        coder.encodeObject(self.Y, forKey: "y")
        coder.encodeObject(self.mOptions, forKey: "o")
        coder.encodeObject(self.Height, forKey: "height")
        coder.encodeObject(self.Width, forKey: "width")
    }
}
