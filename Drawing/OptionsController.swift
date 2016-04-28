//
//  OptionsController.swift
//  Drawing
//
//  Created by Magnan, Alexandre on 2016-02-25.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class OptionsController: UIViewController {
    @IBOutlet var previewView: PreviewView!
    var shapeType = 0
    
    @IBAction func updateLineWidth(sender: AnyObject) {
        tmpOptions.LineWidth = sender.value
        previewView?.setNeedsDisplay()
    }
    @IBAction func LineColorSwitch(sender: AnyObject) {
        tmpOptions.ColorLine = LineColorSeg.selectedSegmentIndex
        previewView?.setNeedsDisplay()
    }

    @IBOutlet weak var LineFillSeg: UISegmentedControl!
    @IBOutlet weak var LineColorSeg: UISegmentedControl!
    @IBOutlet weak var LineWidthSlider: UISlider!
    
    @IBAction func cancelSettings(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func LineFillSwitch(sender: AnyObject) {
        tmpOptions.ColorFill = LineFillSeg.selectedSegmentIndex
        previewView?.setNeedsDisplay()
    }
    @IBOutlet weak var fillLineSwitch: UISwitch!
    @IBAction func saveSettings(sender: AnyObject) {
        
       
        delegate?.setOptions(tmpOptions)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func toggleFill(sender: AnyObject) {
        tmpOptions.FillLine = !tmpOptions.FillLine
        
        if tmpOptions.FillLine{
            LineFillSeg.enabled=true
        }
        else{
            LineFillSeg.enabled=false
        }
        previewView?.setNeedsDisplay()
    }
    @IBOutlet weak var fillColorSeg: UISwitch!
    
    var tmpOptions = Options()
    var delegate:OptionSetting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tmpOptions = Options()
         previewView.myParent=self
        // Do any additional setup after loading the view.
        let parentOptions = delegate?.getOptions()
        tmpOptions = Options(LineWidth: parentOptions!.LineWidth,FillLine: parentOptions!.FillLine,ColorLine: parentOptions!.ColorLine,ColorFill: parentOptions!.ColorFill)
        
        shapeType = (delegate?.getShapeType())!
        fillColorSeg.enabled=tmpOptions.FillLine
        LineWidthSlider.setValue(tmpOptions.LineWidth, animated: true)
        LineColorSeg.selectedSegmentIndex = tmpOptions.ColorLine
        LineFillSeg.selectedSegmentIndex = tmpOptions.ColorFill
        previewView.setNeedsDisplay()
        fillLineSwitch.setOn(tmpOptions.FillLine, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getColorFromIndex(index:Int) -> UIColor{
        return UIColor()
    }


}

protocol OptionSetting{
    func getOptions() -> Options
    func setOptions(options: Options)
    func getShapeType() -> NSInteger
}
