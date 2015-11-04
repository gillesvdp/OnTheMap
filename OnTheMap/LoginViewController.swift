//
//  ViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // IBOutlets
    @IBOutlet weak var emailBackgroundOnlyOutlet: UITextField!
    @IBOutlet weak var passwordBackgroundOnlyOutlet: UITextField!
    @IBOutlet weak var emailUITextFieldOutlet: UITextField!
    @IBOutlet weak var passwordUITextFieldOutlet: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signupButtonOutlet: UIButton!
    
    // Constants and variables
    let udacityAPI = UdacityAPI()
    
    
    // Button Actions
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        // Add checks to see if the textfields are empty or not
        
        udacityAPI.authenticate(emailUITextFieldOutlet.text!, password: passwordUITextFieldOutlet.text!,
            completionHandler: {(success, errorString) -> Void in
            
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("loggedInSuccessfully", sender: nil)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        print(errorString)
                    })
                }
        })
    }
    
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        // Go to sign-up page of Udacity in Safari
        UIApplication.sharedApplication().openURL(NSURL(string:"https://www.udacity.com/account/auth#!/signup")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disabling the 2 UITextFields that are being used as background only
        emailBackgroundOnlyOutlet.enabled = false
        passwordBackgroundOnlyOutlet.enabled = false
    
        // Set placeholder text color to white for the 2 UITextFields
        // Source: http://stackoverflow.com/questions/25679075/set-textfield-placeholder-color-progrmatically-in-swift
        
        emailUITextFieldOutlet.attributedPlaceholder = NSAttributedString(string: emailUITextFieldOutlet.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordUITextFieldOutlet.attributedPlaceholder = NSAttributedString(string: passwordUITextFieldOutlet.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }


}

