//
//  DrawingView.swift
//  Drawing
//
//  Created by Chris Chadillon on 2016-02-10.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class DrawingView: UIView {

    var shapeType = 0
    var shapeSelectedIndex = -1;
    var tmpLines = [Line]()
    var shapes = [Shape]()
    var tmpShape = Shape()
    var oriX = 0.0
    var oriY = 0.0
    var offsetX = 0.0
    var offsetY = 0.0
    var myParent:ViewController?
    var firstMove = false
    var lineFirstTouch = true;
    

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        
        for i in 0..<shapes.count {
            shapes[i].draw(context!)
        }
        
        for i in 0..<tmpLines.count {
            tmpLines[i].draw(context!)
        }
        
        if shapeSelectedIndex != -1 {
            shapes[shapeSelectedIndex].drawBorder(context!)
        }
        tmpShape.draw(context!)
        
        //CGContextStrokePath(context);
       
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        let touch = touches.first! as UITouch
        let location = touch.locationInView(self)

       
        if myParent?.selectorType == 0 {
            //enable the correct buttons for the user to use
            myParent?.eraseBTN.enabled = true;
            myParent?.saveBTN.enabled = true;
            myParent?.undoBTN.enabled = true
//            if shapeType == 3 {
//                if(lineFirstTouch){
//                    //the the starting point for our shape
//                    oriX = Double(location.x)
//                    oriY = Double(location.y)
//                    lineFirstTouch = false
//                }
//                else{
//                    
//                    tmpLines.append(Line(X: oriX, Y: oriY, mOptions: (myParent?.mOptions)!,newX: Double(location.x) , newY: Double(location.y)))
//                    //the the starting point for our shape
//                    oriX = Double(location.x)
//                    oriY = Double(location.y)
//                }
//            }
//            else{
                //the the starting point for our shape
             //}
                oriX = Double(location.x)
                oriY = Double(location.y)
                tmpShape = returnShape(oriX, newY: oriY)
                lineFirstTouch = false
           
    
        }
        else if myParent?.selectorType == 1 {
            shapeSelectedIndex = findShape(location)
            if shapeSelectedIndex != -1 {
                offsetX = Double(location.x) - shapes[shapeSelectedIndex].X
                offsetY = Double(location.y) - shapes[shapeSelectedIndex].Y
            }
        }
        else if myParent?.selectorType == 2 {
            firstMove = true
        }
        
        self.setNeedsDisplay()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let location = touch.locationInView(self)
        if myParent?.selectorType == 0 {
            tmpShape = returnShape(Double(location.x), newY: Double(location.y))
        }
        else if myParent?.selectorType == 1 {
            if shapeSelectedIndex != -1 {
                   shapes[shapeSelectedIndex].moveShape(Double(location.x) - offsetX, newYPoint: Double(location.y) - offsetY)
            }
        }
        else if myParent?.selectorType == 2 {
            if firstMove {
                firstMove = false
                var secondShapeSelectedIndex = -1
                let firstShapeSelectedIndex = findShape(location)
                
                if firstShapeSelectedIndex != -1 {
                    if touches.count > 1 {
                        let touch2 = touches[touches.startIndex.advancedBy(1)]
                        secondShapeSelectedIndex = findShape(touch2.locationInView(self))
                    }
                }
                if firstShapeSelectedIndex == secondShapeSelectedIndex {
                    shapeSelectedIndex = firstShapeSelectedIndex
                }
                else{
                    shapeSelectedIndex = -1
                }
            }
        }
        
        self.setNeedsDisplay()
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        let touch = touches.first! as UITouch
        let location = touch.locationInView(self)
        if myParent?.selectorType == 0 {
            shapes.append(returnShape(Double(location.x), newY: Double(location.y)))
            tmpShape = Shape(X:0,Y:0, mOptions: Options())
            lineFirstTouch = true
            
        }
        else if myParent?.selectorType == 1 {
             if shapeSelectedIndex != -1 {
                shapes[shapeSelectedIndex].moveShape(Double(location.x) - offsetX, newYPoint: Double(location.y) - offsetY)
                shapes.append(shapes[shapeSelectedIndex])
                shapes.removeAtIndex(shapeSelectedIndex)
            }
        }
        else{
            firstMove = false
        }
        shapeSelectedIndex = -1
        self.setNeedsDisplay()
    }
    
    func returnShape(newX : Double, newY : Double ) -> Shape{
        
        //get the width and height based on the new location
        let width = newX - oriX
        let height = newY - oriY
        
        //Create the shape based on the shape type selected by the user
        if shapeType == 0 {
            return Rect(X: oriX, Y: oriY,mOptions: (myParent?.mOptions)!, Height: height, Width: width)
        }
        else if shapeType == 1 {
            return Oval(X: oriX, Y: oriY, mOptions: (myParent?.mOptions)!,Height: height, Width: width)
        }
        else if shapeType == 2{
            return Line(X: oriX, Y: oriY, mOptions: (myParent?.mOptions)!,newX: newX , newY: newY)
        }
        else if shapeType == 3{
            if lineFirstTouch {
                var points = [CGPoint]()
                points.append(CGPoint(x: newX, y: newY))
                return Custom(X: oriX, Y: oriY, mOptions: (myParent?.mOptions)!, points: points)
            }
            else{
                let customShape = tmpShape as! Custom
                var points = customShape.points
                points.append(CGPoint(x: newX, y: newY))
                return Custom(X: oriX, Y: oriY, mOptions: (myParent?.mOptions)!, points: points)
            }
            
        }
        
        return Shape(X:0,Y:0, mOptions: Options())
        
    }
    
    func findShape(location: CGPoint) ->NSInteger{
        
        for(var i = shapes.count-1; i >= 0; i--){
            if (shapes[i].touchInShape(location)) {
                return i;
            }
            
        }
        return -1
    }
    
    func doubleTapped(){
//        if tmpLines.count > 1 {
//            //Once the user double taps, we want to close the shape up from the last point to the first point
//            //Then add it to the shapes
//            tmpLines.append(Line(X: tmpLines[tmpLines.count-1].newX, Y: tmpLines[tmpLines.count-1].newY, mOptions: (myParent?.mOptions)!, newX: tmpLines[0].newX, newY: tmpLines[0].newY))
//            shapes.append(Custom(X: tmpLines[0].X, Y: tmpLines[0].Y, mOptions: (myParent?.mOptions)!, lines: tmpLines))
//            tmpLines = [Line]()
//            lineFirstTouch = true
//        }
    }
    
    func scaleShape(recognizer: UIPinchGestureRecognizer){
        if myParent?.selectorType == 2 {
            if let view = recognizer.view {
                let scale = recognizer.scale
            
                if shapeSelectedIndex != -1 {
                    shapes[shapeSelectedIndex].scale(Double(scale))
                }
                recognizer.scale = 1
            
            }
            if recognizer.state == UIGestureRecognizerState.Ended{
                shapeSelectedIndex = -1
            }
        }
        
        if recognizer.state == UIGestureRecognizerState.Ended{
            shapeSelectedIndex = -1
        }
        
        self.setNeedsDisplay()
    }

}
