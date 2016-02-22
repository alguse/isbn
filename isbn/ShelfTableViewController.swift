//
//  ShelfTableViewController.swift
//  isbn
//
//  Created by Sergio Albarran on 17/02/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import UIKit
import CoreData

class ShelfTableViewController: UITableViewController {

    struct Book {
        var title: String
        var autor: String
    }
    
    var db_books = [NSManagedObject]()
    var books = [Book]()
    var title_back : String = ""
    var autor_back : String = ""
    let appDelegate =
    UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Librero"
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addBook")
        navigationItem.rightBarButtonItems = [add]
        tableView.delegate = self
        tableView.dataSource = self
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Book")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            db_books = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func addBook(){
        self.performSegueWithIdentifier("Search", sender: nil);
    }
    
    func saveBook(title : String, autores : String){
        let li : Book = Book(title: title, autor: autores)
        books.append(li)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return db_books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath) as UITableViewCell
        
        //let row = indexPath.row
        //cell.textLabel?.text = db_books[row].title
        let temp_book = db_books[indexPath.row]
        
        cell.textLabel!.text =
            temp_book.valueForKey("db_title") as? String
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //self.performSegueWithIdentifier("Search", sender: indexPath.row);
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "Search") {
            let sigVista = segue.destinationViewController as! ViewController
            sigVista.firstViewController = self            
            if sender != nil{
            let selectedRow = tableView.indexPathForSelectedRow!.row
            //sigVista.book_r = books[selectedRow]
            let temp_book = db_books[selectedRow]
            sigVista.db_id = temp_book.valueForKey("id") as! String
            }
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context:NSManagedObjectContext = appDelegate.managedObjectContext
            context.deleteObject(db_books[indexPath.row] as NSManagedObject)
            db_books.removeAtIndex(indexPath.row)

            do{
                try context.save()
            }catch {
                abort()
            }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.title_back != "" {
        //let li : Book = Book(title: title_back, autor: autor_back)
            //books.append(li)
            //self.tableView.reloadData()
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Book")
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                db_books = results as! [NSManagedObject]
                self.tableView.reloadData()
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }
}
