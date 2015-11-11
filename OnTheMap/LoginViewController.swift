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
    var appDelegate = AppDelegate()
    
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    
    // Button Actions
    @IBAction func loginButtonPressed(sender: AnyObject) {
        defreezeScreen(false)
        activityIndicatorOutlet.startAnimating()
        
        // Add checks to see if the textfields are empty or not
        
        udacityAPI.login(emailUITextFieldOutlet.text!, password: passwordUITextFieldOutlet.text!,
            completionHandler: {(success, errorString) -> Void in
            
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        self.getUserFullNameAndMoveOnToTheNextScreen()
                    } else {
                        self.endLoginProcess(success, errorString: errorString)
                    }
                })
        })
    }
    
    func getUserFullNameAndMoveOnToTheNextScreen() {
        self.udacityAPI.getUserFullName(DataBuffer.sharedInstance.currentUserKey,
            completionHandler: { (success, errorString) -> Void in
            
                dispatch_async(dispatch_get_main_queue(), {
                    self.endLoginProcess(success, errorString: errorString)
                })
        })
    }
    
    func endLoginProcess(success: Bool, errorString: String?) {
        defreezeScreen(true)
        activityIndicatorOutlet.stopAnimating()
        if success {
            performSegueWithIdentifier("loggedInSuccessfully", sender: nil)
            
        } else {
            displayAlertController(errorString!)
        }
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://www.udacity.com/account/auth#!/signup")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Instantiating the singleton
        _ = DataBuffer()
        
        // Disabling the 2 UITextFields that are being used as background only
        emailBackgroundOnlyOutlet.enabled = false
        passwordBackgroundOnlyOutlet.enabled = false
    
        // Set placeholder text color to white for the 2 UITextFields
        // Source: http://stackoverflow.com/questions/25679075/set-textfield-placeholder-color-progrmatically-in-swift
        
        emailUITextFieldOutlet.attributedPlaceholder = NSAttributedString(string: emailUITextFieldOutlet.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordUITextFieldOutlet.attributedPlaceholder = NSAttributedString(string: passwordUITextFieldOutlet.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        emailUITextFieldOutlet.delegate = self
        passwordUITextFieldOutlet.delegate = self
        emailUITextFieldOutlet.clearButtonMode = .WhileEditing
        passwordUITextFieldOutlet.clearButtonMode = .WhileEditing
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Screen behavior
    
    func defreezeScreen(variable: Bool){
        emailUITextFieldOutlet.enabled = variable
        passwordUITextFieldOutlet.enabled = variable
        loginButtonOutlet.enabled = variable
        signupButtonOutlet.enabled = variable
    }
    
    func displayAlertController(errorString: String) {
        let errorAlert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
    }
    

}

