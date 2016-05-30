//
//  LoginController.swift
//  Hashlist
//
//  Created by Charles Lin on 2/21/16.
//  Copyright © 2016 Hashmedia LLC. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    func alertLoginFail(){
        let alert = UIAlertView()
        alert.title = "Login failed"
        alert.message = "Try again"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    @IBAction func login(sender: AnyObject) {
        if ( usernameInput.text == "" || passwordInput.text == "" ) {
            self.alertLoginFail()
        }
        else {
            let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/hashlistphp_poc/login.php")!)
            request.HTTPMethod = "POST"
            let postString = "username=" + usernameInput.text! + "&password=" + passwordInput.text!
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    dispatch_async(dispatch_get_main_queue(), {
                        self.alertLoginFail()
                    })
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    dispatch_async(dispatch_get_main_queue(), {
                        self.alertLoginFail()
                    })
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                if responseString!.lowercaseString.rangeOfString("error") != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.alertLoginFail()
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), {
                        username = self.usernameInput.text!
                        isLoggedIn = true;
                        self.performSegueWithIdentifier("goToHome", sender: self)
                    })
                }
                print("responseString = \(responseString)")
            }
            task.resume()
        }
        
    }
    
    @IBAction func goToCreateAccount(sender: AnyObject) {
        
    }
}