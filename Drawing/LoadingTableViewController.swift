//
//  LoadingTableViewController.swift
//  Drawing
//
//  Created by Max Handelman on 2016-05-07.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit
import CoreData

class LoadingTableViewController: UITableViewController {

    var drawingTitles = [String]()
    var drawingToLoad = [Shape]()
    var previews = [UIImage]()
    var drawings = [[Shape]]()
    
    override func viewWillAppear(animated: Bool) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        var newData = [NSManagedObject]()
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Drawing")
        
        
        //fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        //TODO: Get the shapes array from the fetch
        //TODO: Get the image perview from the fetch
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            newData = results as! [NSManagedObject]
            
                for i in newData {
    
                    drawingTitles.append(i.valueForKey("name") as! String)
                    let previewImageData = (i.valueForKey("previewImage") as? NSData)
                    
                    //print(previewImageData)
                    
                    let previewImage = UIImage(data: previewImageData!)
                    previews.append(previewImage!)
                    
                    let shapeData = i.valueForKey("shapes") as? NSData
                    let drawing = NSKeyedUnarchiver.unarchiveObjectWithData(shapeData!) as? [Shape]
                    
                    drawings.append(drawing!)
                    
                }
        
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drawingTitles.count
    
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("drawingPreviewCell", forIndexPath: indexPath) as? LoadingViewTableCell

        cell!.drawingTitle?.text = drawingTitles[indexPath.row]
        cell!.previewImage?.image = previews[indexPath.row]
        
        
        return cell!
    }
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        self.drawingToLoad = self.drawings[indexPath.row]
        
        
        print(self.drawingToLoad)
        
        return indexPath
    }
    
    
    // MARK: - Navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        
//       
//        
//    }
    

}
