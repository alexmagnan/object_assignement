//
//  ViewController.swift
//  Drawing
//
//  Created by Chris Chadillon on 2016-02-10.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit
import CoreData

enum shapeTypes {
    
    case rect
    case oval
    case line
    case custom
    
}


class ViewController: UIViewController,OptionSetting{
    var shapeType = 0
    var selectorType = 0;
    
    var drawings = [NSManagedObject]()


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
        
        //MARK: Core Data Load
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        var newData = [NSManagedObject]()
        
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Drawing")
        
        let name = "shit"
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        //TODO: Get the shapes array from the fetch
        //TODO: Get the image perview from the fetch
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            newData = results as! [NSManagedObject]
            
            
            
            
            
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        
    
//        
//        if let data = NSUserDefaults.standardUserDefaults().objectForKey("shapes") as? NSData {
//            drawingView.shapes = ((NSKeyedUnarchiver.unarchiveObjectWithData(data)) as? [Shape])!
//        }
        
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

        //MARK: Save alert
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {
            (action:UIAlertAction) -> Void in
                                        
            let textField = alert.textFields!.first
            
            //TODO: Put this in its own function maybe
            
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate

            let managedContext = appDelegate.managedObjectContext

            let entity =  NSEntityDescription.entityForName("Drawing",
                inManagedObjectContext:managedContext)

            let drawing = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)

            let shapes = NSKeyedArchiver.archivedDataWithRootObject(self.drawingView.shapes)
            
            print(shapes)
            
            let previewImage = UIImage(view: self.drawingView)
            
            drawing.setValue(textField!.text!, forKey: "name")
            drawing.setValue(shapes, forKey: "shapes")
            //drawing.setValue(previewImage, forKey: "previewImage")
            

            //4
            do {
                try managedContext.save()
                //5
                self.drawings.append(drawing)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
                                        
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
            (action: UIAlertAction) -> Void in
        
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: false, completion: nil)

        
        /* Create the binary data */
        
        
        
        //TODO - Write it to the database
        
        
        //NSUserDefaults.standardUserDefaults().setObject(data, forKey: "shapes")
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
        
        
        //TODO: Change this to core data implementation
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("shapes") as? NSData {
            loadBTN.enabled = true;
        }
        
        
        let tap = UITapGestureRecognizer(target: drawingView, action: #selector(ViewController.doubleTapped))
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

