//
//  Options.swift
//  Drawing
//
//  Created by Magnan, Alexandre on 2016-03-10.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class Options: NSObject, NSCoding{
    var LineWidth: Float
    var FillLine: Bool
    var ColorLine: Int
    var ColorFill: Int
    let components: [[CGFloat]] = [[1.0, 0.0, 0.0, 1.0],[0.0, 0.0, 1.0, 1.0],[0.0, 1.0, 0.0, 1.0],[1.0, 1.0, 0.0, 1.0],[1.0, 0.549, 0.0, 1.0],[0.0, 0.0, 0.0, 1.0]]
    
    override
    init(){
        self.LineWidth = 1
        self.FillLine = false
        self.ColorLine = 0
        self.ColorFill = 0
    }
    init(LineWidth: Float, FillLine: Bool,ColorLine: Int, ColorFill:Int){
        self.LineWidth = LineWidth
        self.FillLine = FillLine
        self.ColorLine = ColorLine
        self.ColorFill = ColorFill
    }
    required convenience init?(coder decoder: NSCoder) {
        guard let lineWidth = decoder.decodeObjectForKey("lineWidth") as? Float,
            let fillLine = decoder.decodeObjectForKey("fillLine") as? Bool,
            let colorLine = decoder.decodeObjectForKey("colorLine") as? Int,
            let colorFill = decoder.decodeObjectForKey("colorFill") as? Int
            else{return nil}
        
        self.init (
            LineWidth: lineWidth,
            FillLine: fillLine,
            ColorLine: colorLine,
            ColorFill: colorFill
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.LineWidth, forKey: "lineWidth")
        coder.encodeObject(self.FillLine, forKey: "fillLine")
        coder.encodeObject(self.ColorLine, forKey: "colorLine")
        coder.encodeObject(self.ColorFill, forKey: "colorFill")
    }
    
    func getColorFromIndex(index:Int) -> UIColor{
        return UIColor()
    }
}