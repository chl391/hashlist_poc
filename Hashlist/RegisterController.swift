//
//  RegisterController.swift
//  Hashlist
//
//  Created by Charles Lin on 2/21/16.
//  Copyright © 2016 Hashmedia LLC. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    func alertRegisterFail(){
        let alert = UIAlertView()
        alert.title = "Register failed"
        alert.message = "Try again"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func alertRegisterSuccess(){
        let alert = UIAlertView()
        alert.title = "Register success"
        alert.message = "Hash it up!"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/hashlistphp_poc/register.php")!)
        request.HTTPMethod = "POST"
        let postString = "username=" + username.text! + "&email=" + email.text! + "&password=" + password.text!
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertRegisterFail()
                })
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertRegisterFail()
                })
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            if responseString!.lowercaseString.rangeOfString("error") != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertRegisterFail()
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertRegisterSuccess()
                    self.performSegueWithIdentifier("goToLogin", sender: self)
                })
            }
            print("responseString = \(responseString)")
        }
        task.resume()
    }
}