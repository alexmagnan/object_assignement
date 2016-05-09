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
        
        if(points.count > 1){
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
    override func scale(scale: Double){
//        for i in 0..<points.count {
//            let Width = self.newX - X
//            let Height = self.newY - Y
//            let scaledWidth = Width * scale
//            let scaledHeight = Height * scale
//        
//            let newX = (Width - scaledWidth)/2
//            let newY = (Height - scaledHeight)/2
//            self.X = self.X + newX
//            self.Y = self.Y + newY
//            self.newX = self.X + scaledWidth
//            self.newY = self.Y + scaledHeight
//        }
        
    }
    override func drawBorder(context: CGContext) {
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
        
        let borderWidth = highestX - lowestX
        let borderHeight = highestY - lowestY
        
        let rect = CGRect(x: lowestX - 2, y: lowestY - 2, width: borderWidth + 4, height: borderHeight + 2)
        
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
    required convenience init?(coder decoder: NSCoder) {
        
        var pointsAsCGPoints = [CGPoint]()
        
        guard let x = decoder.decodeObjectForKey("x") as? Double,
            let y = decoder.decodeObjectForKey("y") as? Double,
            let o = decoder.decodeObjectForKey("o") as? Options,
            let pointsAsStrings = decoder.decodeObjectForKey("pointsAsStrings") as? [String]
            else { return nil }
        
        for point in pointsAsStrings {
            
            pointsAsCGPoints.append(CGPointFromString(point))
            
        }
    
        self.init (
            X: x,
            Y: y,
            mOptions: o,
            points: pointsAsCGPoints
        )
    }
    
    override func touchInShape(location: CGPoint) -> Bool{
        if(points.count > 1){
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
            
            let Width = highestX - lowestX
            let Height = highestY - lowestY
            
            if (CGRectContainsPoint(CGRect(x: Double(lowestX), y: Double(lowestY), width: Double(Width), height: Double(Height)), CGPoint(x: location.x, y: location.y))) {
                return true;
            }

        }
        return false
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.X, forKey: "x")
        coder.encodeObject(self.Y, forKey: "y")
        coder.encodeObject(self.mOptions, forKey: "o")
        
        var pointsAsStrings = [String]()
        
        for point in self.points {
            
            pointsAsStrings.append(NSStringFromCGPoint(point))
            
        }
        
        coder.encodeObject(pointsAsStrings, forKey: "pointsAsStrings")
        
    }
}
