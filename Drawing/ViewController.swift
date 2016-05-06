//
//  ViewController.swift
//  Drawing
//
//  Created by Chris Chadillon on 2016-02-10.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit


enum shapeTypes {
    
    
    case rect
    case oval
    case line
    case custom
    
    
    

}


class ViewController: UIViewController,OptionSetting{
    var shapeType = 0
    var selectorType = 0;

    
    var currentShapeType = shapeTypes.line
    
    
    @IBOutlet var drawingView: DrawingView!


    @IBOutlet weak var saveBTN: UIBarButtonItem!
    @IBOutlet weak var loadBTN: UIBarButtonItem!
    @IBOutlet weak var currentShapeButton: UIBarButtonItem!
    @IBAction func changeCurrentShape(sender: AnyObject) {
    
    
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        
        let selectRect = UIAlertAction(title: "Rectangle", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.currentShapeType = .rect
            self.currentShapeButton.title = "Rectangle"
            self.drawingView.shapeType = 0
            
        })
        let selectOval = UIAlertAction(title: "Oval", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.currentShapeType = .oval
            self.currentShapeButton.title = "Oval"
            self.drawingView.shapeType = 1
        })
        
        let selectLine = UIAlertAction(title: "Line", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.currentShapeType = .line
            self.currentShapeButton.title = "Line"
            self.drawingView.shapeType = 2
        })
        
        
        
        //
        let selectCustom = UIAlertAction(title: "Custom", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.currentShapeType = .custom
            self.currentShapeButton.title = "Custom"
            self.drawingView.shapeType = 3
            
        })
        
        let selectCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in

        })

        
        // 4
        optionMenu.addAction(selectRect)
        optionMenu.addAction(selectLine)
        optionMenu.addAction(selectOval)
        optionMenu.addAction(selectCustom)
        optionMenu.addAction(selectCancel)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
        
    
    
    
    
    
    @IBOutlet weak var eraseBTN: UIBarButtonItem!
    @IBOutlet weak var undoBTN: UIBarButtonItem!
    
    var mOptions = Options();
    @IBAction func Erase(sender: AnyObject)
    {
        //Reset the variables
        drawingView.shapes = [Shape]();
        drawingView.tmpShape = Shape(X:0,Y:0,mOptions:mOptions);
        drawingView.multiLineFirst = true
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
        if shapeType == 4{
            let tmpMirror = Mirror(reflecting: drawingView.tmpShape)
            if tmpMirror.subjectType == Custom.self {
                let customShape = drawingView.tmpShape as! Custom
                var points = customShape.points
                points.popLast()
                if points.count == 0 {
                    drawingView.tmpShape = Shape(X:0,Y:0, mOptions: Options())
                }
                else {
                    drawingView.tmpShape = Custom(X: drawingView.tmpShape.X, Y: drawingView.tmpShape.Y, mOptions: mOptions, points: points)
                }
                drawingView.setNeedsDisplay();
            }
            else {
                drawingView.shapes.removeLast()
                //Redraw the shapes now that they are loaded
                drawingView.setNeedsDisplay();
            }
        }
        else if drawingView.shapes.count > 0{
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
        
        /* Create the binary data */
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(drawingView.shapes)
        
        //TODO - Write it to the database
        
        
        
        
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
        
        currentShapeType = shapeTypes.rect
        
        drawingView.myParent = self;
        
        currentShapeButton.title = "Rectangle"
        
        
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("shapes") as? NSData {
            loadBTN.enabled = true;
        }
        
        
        let tap = UITapGestureRecognizer(target: drawingView, action: "doubleTapped")
        tap.numberOfTapsRequired = 2
        drawingView.addGestureRecognizer(tap)
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
        
        if segue.identifier == "showOptions" {
        
            let viewController:OptionsController = segue.destinationViewController as! OptionsController
            viewController.delegate = self
                
        } else if segue.identifier == "showLoading" {
            
            
            
        }
    }
    
    func doubleTapped() {
       drawingView.doubleTapped()
    }
    
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

