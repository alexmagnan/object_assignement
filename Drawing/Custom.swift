//
//  Custom.swift
//  Drawing
//
//  Created by Student on 2016-04-22.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class Custom:Shape {
    var points : [CGPoint]
    
    init(X: Double, Y: Double, mOptions: Options, points: [CGPoint]) {
        self.points = points
        super.init(X: X, Y: Y,mOptions: mOptions)
    }
    
    override func draw(context: CGContext) {
        let bezierPath = UIBezierPath()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var components: [CGFloat] = mOptions.components[0]
        var color = CGColorCreate(colorSpace, components)
        
        if(points.count > 2){
            bezierPath.moveToPoint(points[0])
            for i in 1..<points.count {
                bezierPath.addLineToPoint(points[i])
            }
            
            CGContextSetLineWidth(context, CGFloat(mOptions.LineWidth))
            components = mOptions.components[mOptions.ColorLine]
            color = CGColorCreate(colorSpace, components)
            CGContextSetStrokeColorWithColor(context, color)
            CGContextStrokePath(context)
            
            bezierPath.stroke()
        }
    }
    
    override func moveShape(newXPoint: Double, newYPoint: Double){
        for i in 0..<points.count {
            let oldX = Double(points[i].x) - X
            let oldY = Double(points[i].y) - Y
            points[i].x = CGFloat(oldX + newXPoint)
            points[i].y = CGFloat(oldY + newYPoint)
        }
        X = newXPoint
        Y = newYPoint
        
       
    }
    override func drawBorder(context: CGContext) {
//        //We have to calculate the new border according to the width and height if they are negative or not
//        var borderX = 0.0
//        var borderY = 0.0
//        var borderWidth = 0.0
//        var borderheight = 0.0
//        
//        if self.Width > 0.0 && self.Height > 0.0 {
//            borderX = self.X - 3
//            borderY = self.Y - 3
//            borderWidth = self.Width + 6
//            borderheight = self.Height + 6
//        }
//        else if self.Width < 0.0 && self.Height < 0.0 {
//            borderX = self.X + 3
//            borderY = self.Y + 3
//            borderWidth = self.Width - 6
//            borderheight = self.Height - 6
//        }
//        else if self.Width > 0.0 && self.Height < 0.0 {
//            borderX = self.X - 3
//            borderY = self.Y + 3
//            borderWidth = self.Width + 6
//            borderheight = self.Height - 6
//        }
//        else if self.Width < 0.0 && self.Height > 0.0 {
//            borderX = self.X + 3
//            borderY = self.Y - 3
//            borderWidth = self.Width - 6
//            borderheight = self.Height + 6
//        }
//        
//        let rect = CGRect(x: borderX, y: borderY, width: borderWidth, height: borderheight)
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        var components: [CGFloat] = mOptions.components[0]
//        var color = CGColorCreate(colorSpace, components)
//        
//        CGContextSetLineWidth(context, 1)
//        components = mOptions.components[3]
//        color = CGColorCreate(colorSpace, components)
//        CGContextSetStrokeColorWithColor(context, color)
//        CGContextAddRect(context, rect)
//        CGContextStrokePath(context)
    }
    required convenience init?(coder decoder: NSCoder) {
        guard let points = decoder.decodeObjectForKey("points") as? [CGPoint],
            let x = decoder.decodeObjectForKey("x") as? Double,
            let y = decoder.decodeObjectForKey("y") as? Double,
            let o = decoder.decodeObjectForKey("o") as? Options
            else { return nil }
        
        self.init (
            X: x,
            Y: y,
            mOptions: o,
            points: points
        )
    }
    override func scale(scale: Double){
//        let scaledWidth = self.Width * scale
//        let scaledHeight = self.Height * scale
//        
//        let newX = (self.Width - scaledWidth)/2
//        let newY = (self.Height - scaledHeight)/2
//        self.X = self.X + newX
//        self.Y = self.Y + newY
//        self.Width = scaledWidth
//        self.Height = scaledHeight
        
    }
    
    override func touchInShape(location: CGPoint) -> Bool{
        if(points.count > 2){
            var highestX = points[0].x
            var highestY = points[0].y
            var lowestX = points[0].x
            var lowestY = points[0].y
            
            for i in 1..<points.count {
                if highestX < points[i].x{
                    highestX = points[i].x
                }
                if highestY < points[i].y{
                    highestY = points[i].y
                }
                if lowestX > points[i].x{
                    lowestX = points[i].x
                }
                if lowestY > points[i].y{
                    lowestY = points[i].y
                }
            }
            
            let Height = highestX - lowestX
            let Width = highestY - lowestY
            
            if (CGRectContainsPoint(CGRect(x: Double(lowestX), y: Double(highestY), width: Double(Width), height: Double(Height)), CGPoint(x: location.x, y: location.y))) {
                return true;
            }

        }
        return false
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.X, forKey: "x")
        coder.encodeObject(self.Y, forKey: "y")
        coder.encodeObject(self.mOptions, forKey: "o")
//        coder.encodeObject(self.points, forKey: "points")
    }
}
