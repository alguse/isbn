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
                    let texto = NSString(data:datos!, encoding: NSUTF8StringEncoding)
                    print(texto!)
                    self.result.text = texto! as String
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
                    let texto = NSString(data:datos!, encoding: NSUTF8StringEncoding)
                    print(texto!)
                    self.result.text = texto! as String
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
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

