//
//  ViewController.swift
//  isbn
//
//  Created by Sergio Albarran on 08/02/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var num: UITextField!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var result: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        num.delegate = self
        num.returnKeyType = UIReturnKeyType.Search

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func clear(sender: AnyObject) {
    num.text = ""
        result.text = ""
    }
    
    @IBAction func search(sender: AnyObject) {
        if Reach.isConnectedToNetwork() == true {
            
            if num.text != ""{
                let op = num.text
                let urls1 = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(op!)"
                let urls = urls1.stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                let url = NSURL(string: urls)
                let sesion = NSURLSession.sharedSession()
                let bloque = { (datos: NSData?,resp: NSURLResponse?, error:  NSError? )-> Void in  dispatch_sync(dispatch_get_main_queue()) {
                    //let texto = NSString(data:datos!, encoding: NSUTF8StringEncoding)
                    do {
                        /*
                            let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                            let d1 = json[0] as! NSDictionary
                            guard let item = d1["title"] as? [String: AnyObject],
                                let book = item["ISBN:978-84-376-0494-7"] as? [String: AnyObject],
                                let age = book["title"] as? String else {
                                    return;
                            }
*/
                        let jsonObject = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        
                        if let bookDictionary: AnyObject = jsonObject!["ISBN:\(self.num.text!)"] {
                            let title : String = bookDictionary["title"] as! String
                           self.result.text = "Titulo: \(title)\n"
                            var names = [String]()
                            if let authors = bookDictionary["authors"] as? NSArray {
                                for author in authors {
                                    if let author = author as? NSDictionary,
                                        let name = author["name"] as? String {
                                            names.append(name)
                                    }
                                }
                            }
                            let strinIng = names.joinWithSeparator(", ")
                            self.result.text =                        self.result.text + "Autores: \n"  + strinIng

                            // Retrieve cover url
                            var coverThumbURL: String = ""
                            if let thumbs = bookDictionary["cover"] as? NSDictionary {
                                let thumbnail = thumbs.valueForKey("medium") as? String
                                coverThumbURL = thumbnail!
                                let urlI = NSURL(string:coverThumbURL)
                                
                                self.result.text = self.result.text + "\nImagen: " + coverThumbURL

                                let dataI = NSData(contentsOfURL: urlI!)
                                    self.cover.image = UIImage(data: dataI!)
                            }else{
                                self.result.text = self.result.text + "\nImagen no disponible "
                            }
                        }
                    }catch _ {}
                    
                    }
                }
                let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
                dt.resume()
                num.resignFirstResponder()
            }else{
                result.text = "No se encontró información"
            }
        } else {
            let alertController = UIAlertController(title: "iOS Connect", message:
                "Porfavor revisa tu conexión a Internet", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
            }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if Reach.isConnectedToNetwork() == true {
            
            if num.text != ""{
                let op = num.text
                let urls1 = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(op!)"
                let urls = urls1.stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                let url = NSURL(string: urls)
                let sesion = NSURLSession.sharedSession()
                let bloque = { (datos: NSData?,resp: NSURLResponse?, error:  NSError? )-> Void in  dispatch_sync(dispatch_get_main_queue()) {
                    //let texto = NSString(data:datos!, encoding: NSUTF8StringEncoding)
                    do {
                        /*
                        let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                        let d1 = json[0] as! NSDictionary
                        guard let item = d1["title"] as? [String: AnyObject],
                        let book = item["ISBN:978-84-376-0494-7"] as? [String: AnyObject],
                        let age = book["title"] as? String else {
                        return;
                        }
                        */
                        let jsonObject = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        
                        if let bookDictionary: AnyObject = jsonObject!["ISBN:\(self.num.text!)"] {
                            let title : String = bookDictionary["title"] as! String
                            self.result.text = "Titulo: \(title)\n"
                            var names = [String]()
                            if let authors = bookDictionary["authors"] as? NSArray {
                                for author in authors {
                                    if let author = author as? NSDictionary,
                                        let name = author["name"] as? String {
                                            names.append(name)
                                    }
                                }
                            }
                            let strinIng = names.joinWithSeparator(", ")
                            self.result.text =                        self.result.text + "Autores: \n"  + strinIng
                            
                            // Retrieve cover url
                            var coverThumbURL: String = ""
                            if let thumbs = bookDictionary["cover"] as? NSDictionary {
                                let thumbnail = thumbs.valueForKey("medium") as? String
                                coverThumbURL = thumbnail!
                                let urlI = NSURL(string:coverThumbURL)
                                
                                self.result.text = self.result.text + "\nImagen: " + coverThumbURL
                                
                                let dataI = NSData(contentsOfURL: urlI!)
                                self.cover.image = UIImage(data: dataI!)
                            }else{
                                self.result.text = self.result.text + "\nImagen no disponible "
                            }
                        }
                    }catch _ {}
                    
                    }
                }
                let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
                dt.resume()
                num.resignFirstResponder()
            }else{
                result.text = "No se encontró información"
            }
        } else {
            let alertController = UIAlertController(title: "iOS Connect", message:
                "Porfavor revisa tu conexión a Internet", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

