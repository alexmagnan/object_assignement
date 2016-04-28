//
//  ViewController.swift
//  Drawing
//
//  Created by Chris Chadillon on 2016-02-10.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,OptionSetting{
    var shapeType = 0
    var selectorType = 0;
    @IBOutlet var drawingView: DrawingView!

    @IBOutlet weak var saveBTN: UIBarButtonItem!
    @IBOutlet weak var loadBTN: UIBarButtonItem!
    @IBOutlet weak var eraseBTN: UIBarButtonItem!
    @IBOutlet weak var undoBTN: UIBarButtonItem!
    
    var mOptions = Options();
    @IBAction func Erase(sender: AnyObject)
    {
        //Reset the variables
        drawingView.shapes = [Shape]();
        drawingView.tmpShape = Shape(X:0,Y:0,mOptions:mOptions);
        drawingView.tmpLines = [Line]()
        //Empty the screen
        drawingView.setNeedsDisplay();
        
        //Disable the buttons that we don't need
        eraseBTN.enabled = false;
        saveBTN.enabled = false;
        undoBTN.enabled = false
    }
    
    
    @IBAction func Load(sender: AnyObject)
    {
        //Clear the screen before restoring shapes
        Erase(sender)
        
        //Get the shapes from the Archiver
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("shapes") as? NSData {
            drawingView.shapes = ((NSKeyedUnarchiver.unarchiveObjectWithData(data)) as? [Shape])!
            
        }
        //Redraw the shapes now that they are loaded
        drawingView.setNeedsDisplay();
        
        //Disable the buttons that we don't need
        eraseBTN.enabled = true;
        saveBTN.enabled = true;
    }
    @IBAction func UndoShape(sender: AnyObject) {
        
        if drawingView.shapes.count > 0{
            drawingView.shapes.removeLast()
            //Redraw the shapes now that they are loaded
            drawingView.setNeedsDisplay();
        }
        
        if drawingView.shapes.count == 0 {
            Erase(sender)
        }
       
    }
    
    @IBAction func ScaleShape(sender: UIPinchGestureRecognizer) {
        if selectorType == 2 {
            drawingView.scaleShape(sender)
        }
        
    }
    @IBAction func Save(sender: AnyObject)
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(drawingView.shapes)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "shapes")
        loadBTN.enabled = true;
    }
    @IBAction func changeShape(sender: UISegmentedControl) {
        drawingView.shapeType = sender.selectedSegmentIndex
        shapeType = sender.selectedSegmentIndex
    }

    @IBAction func ChangeType(sender: AnyObject) {
        selectorType = sender.selectedSegmentIndex
        
    }
    @IBOutlet weak var optionsBTN: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawingView.myParent = self;
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("shapes") as? NSData {
            loadBTN.enabled = true;
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: "doubleTapped")
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        //TODO: enable save and erase only when needed
//        eraseBTN.enabled = true;
//        saveBTN.enabled = true;
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let viewController:OptionsController = segue.destinationViewController as! OptionsController
        viewController.delegate = self
    }
    
    func doubleTapped() {
       drawingView.doubleTapped()
    }
    
//
//    func prepareMove(){
//        if drawingView.selectorMode {
//            eraseBTN.enabled = false
//            undoBTN.enabled = false
//            saveBTN.enabled = false
//            loadBTN.enabled = false
//            optionsBTN.enabled = false
//        }
//        else {
//            loadBTN.enabled = true
//            optionsBTN.enabled = true
//            if drawingView.shapes.count != 0 {
//                eraseBTN.enabled = true
//                undoBTN.enabled = true
//                saveBTN.enabled = true
//            }
//        }
//        
//    }
    func getOptions() -> Options {
        return mOptions
    }
    func setOptions(options: Options) {
        mOptions = Options(LineWidth: options.LineWidth,FillLine: options.FillLine,ColorLine: options.ColorLine,ColorFill: options.ColorFill)
    }
    func getShapeType() -> NSInteger{
        return shapeType
    }

}

