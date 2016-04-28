//
//  PreviewView.swift
//  Drawing
//
//  Created by Magnan, Alexandre on 2016-03-10.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class PreviewView: UIView {
    var myParent:OptionsController?
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, CGFloat((myParent?.tmpOptions.LineWidth)!))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        
        let preview = returnShape()
        preview.draw(context!);

        
        CGContextStrokePath(context);
    }
  
    func returnShape() -> Shape{
        let width=self.bounds.width
        let height=self.bounds.height
        
        //Create the shape based on the shape type selected by the user
        if myParent?.shapeType == 0 {
            return Rect(X: 5, Y: 5,mOptions: (myParent?.tmpOptions)!, Height: Double(height-10), Width: Double(width-10))
        }
        else if myParent?.shapeType == 1 {
            return Oval(X: 5, Y: 5,mOptions: (myParent?.tmpOptions)!, Height: Double(height-10), Width: Double(width-10))
        }
        else {
            return Line(X: 5, Y: 5, mOptions: (myParent?.tmpOptions)!,newX: Double(width-10), newY: Double(height-10))
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
