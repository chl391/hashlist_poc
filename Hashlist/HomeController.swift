//
//  ViewController.swift
//  Hashlist
//
//  Created by Charles Lin on 2/6/16.
//  Copyright © 2016 Hashmedia LLC. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var hashtagInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        usernameLabel.text = "@" + username
        self.performSegueWithIdentifier("goToLogin", sender: self)
        
        self.getHashtagsAndDisplay()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addHashtag(sender: AnyObject) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/hashlistphp_poc/addhashtag.php")!)
        request.HTTPMethod = "POST"
        let postString = "username=" + username + "&hashtag=" + hashtagInput.text!
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                // alert fail
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                // alert fail
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            if responseString!.lowercaseString.rangeOfString("error") != nil {
                //alert fail
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    //alert success
                    //refresh
                    self.getHashtagsAndDisplay()
                })
            }
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        username = "";
        isLoggedIn = false;
    }
    
    func buttonAction(sender:UIButton!)
    {
        let deleteLabel = hashtagLabels[sender.tag-1].text
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/hashlistphp_poc/deletehashtag.php")!)
        request.HTTPMethod = "POST"
        let postString = "username=" + username + "&hashtag=" + deleteLabel!
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                // alert fail
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                // alert fail
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            if responseString!.lowercaseString.rangeOfString("error") != nil {
                //alert fail
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.getHashtagsAndDisplay()
                })
            }
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    func messageUser(sender:UIButton!) {
        let msgSender = username
        let msgReceiver = userLabels[sender.tag-1].text!
        let message = inputFields[sender.tag-1].text!
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/hashlistphp_poc/addmessage.php")!)
        request.HTTPMethod = "POST"
        let postString = "username=" + username + "&receiver=" + msgReceiver + "&message=" + message
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                // alert fail
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                // alert fail
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            if responseString!.lowercaseString.rangeOfString("error") != nil {
                //alert fail
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView()
                    alert.title = "Message Sent!"
                    alert.message = responseString
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                })
            }
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    func getHashtagsAndDisplay(){
        // Delete previous hashtag labels and buttons
        for hashtagLabel in hashtagLabels {
            hashtagLabel.removeFromSuperview()
        }
        
        for userLabel in userLabels {
            userLabel.removeFromSuperview()
        }
        
        for deleteButton in deleteButtons {
            deleteButton.removeFromSuperview()
        }
        
        for inputField in inputFields {
            inputField.removeFromSuperview()
        }
        
        hashtagLabels.removeAll()
        userLabels.removeAll()
        deleteButtons.removeAll()
        inputFields.removeAll()
        
        //
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/hashlistphp_poc/gethashtag.php")!)
        request.HTTPMethod = "POST"
        let postString = "username=" + username
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        var hashtagsString : NSString = NSString()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                // alert fail
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                // alert fail
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            if responseString!.lowercaseString.rangeOfString("error") != nil {
                //alert fail
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    //alert success
                    //refresh
                })
            }
            print("responseString = \(responseString)")
            hashtagsString = responseString!
            
            /*
            let str = "{\"hashtags\": [\"Bob\", \"Tim\", \"Tina\"]}"
            let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            
            do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
            if let hashtags = json["hashtags"] as? [String] {
            print(hashtags)
            }
            } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            }
            */
            
            let hashtagsArray = responseString!.componentsSeparatedByString("|")
            
            
            dispatch_async(dispatch_get_main_queue(), {
                /*
                let alert = UIAlertView()
                alert.title = "Success"
                alert.message = responseString
                alert.addButtonWithTitle("Ok")
                alert.show()
                */
                number = 125
                for hashtag in hashtagsArray {
                    let label = UILabel(frame: CGRectMake(0, number, 200, 21))
                    label.center = CGPointMake(125, number)
                    label.textAlignment = NSTextAlignment.Center
                    label.text = hashtag
                    self.view.addSubview(label)
                    hashtagLabels.append(label)
                
                    if (hashtagsArray[0].isEmpty == false){
                        let button = UIButton(type: UIButtonType.System) as UIButton
                        button.frame = CGRectMake(175, number-7.5, 50, 15)
                        button.tag = hashtagLabels.count
                        button.setTitle("Delete", forState: UIControlState.Normal)
                        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                        self.view.addSubview(button)
                        deleteButtons.append(button)
                    }
                    number = number + 25
                }
                number = number + 10
                
                
                // Display list of matching users
                self.getUsersAndDisplay()
            })
        }
        task.resume()
    }
    
    func getUsersAndDisplay() {
        // load users label
        let label = UILabel(frame: CGRectMake(0, number, 200, 21))
        label.center = CGPointMake(158, number)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Users"
        label.textColor = UIColor.whiteColor()
        self.view.addSubview(label)
        hashtagLabels.append(label)
        
        number = number + 25
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/hashlistphp_poc/getmatchingusers.php")!)
        request.HTTPMethod = "POST"
        let postString = "username=" + username
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                // alert fail
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                // alert fail
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            if responseString!.lowercaseString.rangeOfString("error") != nil {
                //alert fail
            }
            else {
                let usersArray = responseString!.componentsSeparatedByString("|")
                dispatch_async(dispatch_get_main_queue(), {
                    for user in usersArray {
                        let label = UILabel(frame: CGRectMake(0, number, 200, 21))
                        label.center = CGPointMake(50, number)
                        label.textAlignment = NSTextAlignment.Center
                        label.text = user
                        self.view.addSubview(label)
                        userLabels.append(label)
                        
                        if (usersArray[0].isEmpty == false){
                            // Display text boxes
                            let txtField: UITextField = UITextField(frame: CGRect(x: 105, y: number-15, width: 100.00, height: 30.00))
                            txtField.backgroundColor = UIColor.whiteColor()
                            self.view.addSubview(txtField)
                            inputFields.append(txtField)
                            
                            // Display message buttons
                            let button = UIButton(type: UIButtonType.System) as UIButton
                            button.frame = CGRectMake(220, number-7.5, 75, 15)
                            button.setTitle("Message", forState: UIControlState.Normal)
                            button.addTarget(self, action: "messageUser:", forControlEvents: UIControlEvents.TouchUpInside)
                            button.tag = userLabels.count
                            self.view.addSubview(button)
                            deleteButtons.append(button)
                        }
                        
                        number = number + 35
                    }
                    self.getMessagesAndDisplay()
                })
            }
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    func getMessagesAndDisplay(){
        // load users label
        let label = UILabel(frame: CGRectMake(0, number, 200, 21))
        label.center = CGPointMake(158, number)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Messages"
        label.textColor = UIColor.whiteColor()
        self.view.addSubview(label)
        hashtagLabels.append(label)
        
        number = number + 25
        
        let senderLabel = UILabel(frame: CGRectMake(0, number, 200, 21))
        senderLabel.center = CGPointMake(75, number)
        senderLabel.textAlignment = NSTextAlignment.Center
        senderLabel.text = "Sender"
        senderLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(senderLabel)
        hashtagLabels.append(senderLabel)
        
        let messageLabel = UILabel(frame: CGRectMake(0, number, 200, 21))
        messageLabel.center = CGPointMake(225, number)
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.text = "Message"
        messageLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(messageLabel)
        hashtagLabels.append(messageLabel)
        
        number = number + 25
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/hashlistphp_poc/getmessages.php")!)
        request.HTTPMethod = "POST"
        let postString = "username=" + username
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                // alert fail
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                // alert fail
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            if responseString!.lowercaseString.rangeOfString("error") != nil {
                //alert fail
            }
            else {
                let messagesArray = responseString!.componentsSeparatedByString("||")
                dispatch_async(dispatch_get_main_queue(), {
                    for message in messagesArray {
                        let messageData = message.componentsSeparatedByString("|")
                        if (messageData.count > 1){
                            let senderLabel = UILabel(frame: CGRectMake(0, number, 200, 21))
                            senderLabel.center = CGPointMake(75, number)
                            senderLabel.textAlignment = NSTextAlignment.Center
                            senderLabel.text = messageData[1]
                            senderLabel.textColor = UIColor.blackColor()
                            self.view.addSubview(senderLabel)
                            hashtagLabels.append(senderLabel)
                        
                            let messageLabel = UILabel(frame: CGRectMake(0, number, 200, 21))
                            messageLabel.center = CGPointMake(225, number)
                            messageLabel.textAlignment = NSTextAlignment.Center
                            messageLabel.text = messageData[0]
                            messageLabel.textColor = UIColor.blackColor()
                            self.view.addSubview(messageLabel)
                            hashtagLabels.append(messageLabel)
                        
                            number = number + 25
                        }
                    }
                    /*
                    for user in usersArray {
                        let label = UILabel(frame: CGRectMake(0, number, 200, 21))
                        label.center = CGPointMake(50, number)
                        label.textAlignment = NSTextAlignment.Center
                        label.text = user
                        self.view.addSubview(label)
                        userLabels.append(label)
                        
                        if (usersArray[0].isEmpty == false){
                            // Display text boxes
                            let txtField: UITextField = UITextField(frame: CGRect(x: 105, y: number-15, width: 100.00, height: 30.00))
                            txtField.backgroundColor = UIColor.whiteColor()
                            self.view.addSubview(txtField)
                            inputFields.append(txtField)
                            
                            // Display message buttons
                            let button = UIButton(type: UIButtonType.System) as UIButton
                            button.frame = CGRectMake(220, number-7.5, 75, 15)
                            button.setTitle("Message", forState: UIControlState.Normal)
                            button.addTarget(self, action: "messageUser:", forControlEvents: UIControlEvents.TouchUpInside)
                            button.tag = userLabels.count
                            self.view.addSubview(button)
                            deleteButtons.append(button)
                        }
                        
                        number = number + 35
                    }*/
                })
            }
            print("responseString = \(responseString)")
        }
        task.resume()    }
    
}

