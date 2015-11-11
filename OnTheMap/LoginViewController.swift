//
//  ViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Constants and variables
    let udacityAPI = UdacityAPI()
    var appDelegate = AppDelegate()
    
    // MARK: IBOutlets
    @IBOutlet weak var emailBackgroundOnlyOutlet: UITextField!
    @IBOutlet weak var passwordBackgroundOnlyOutlet: UITextField!
    @IBOutlet weak var emailUITextFieldOutlet: UITextField!
    @IBOutlet weak var passwordUITextFieldOutlet: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signupButtonOutlet: UIButton!
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    
    // MARK: Button Actions
    @IBAction func loginButtonPressed(sender: AnyObject) {
        if textFieldsAreEmpty() {
            displayAlertController(ConstantStrings.sharedInstance.emptyFields)
            
        } else {
            defreezeScreen(false)
            activityIndicatorOutlet.startAnimating()
            udacityAPI.login(emailUITextFieldOutlet.text!, password: passwordUITextFieldOutlet.text!,
                completionHandler: {(userKey, errorString) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if let _ = errorString {
                            self.endLoginProcess(errorString)
                            
                        } else {
                            DataBuffer.sharedInstance.currentUserKey = userKey!
                            self.getUserFullNameAndMoveOnToTheNextScreen()
                        }
                    })
            })
        }
        
        
    }
    
    func getUserFullNameAndMoveOnToTheNextScreen() {
        self.udacityAPI.getUserFullName(DataBuffer.sharedInstance.currentUserKey,
            completionHandler: { (userFirstName, userLastName, errorString) -> Void in
            
                dispatch_async(dispatch_get_main_queue(), {
                    if let _ = errorString {
                        self.endLoginProcess(errorString)
                    } else {
                        DataBuffer.sharedInstance.currentUserFirstName = userFirstName!
                        DataBuffer.sharedInstance.currentUserLastName = userLastName!
                        self.endLoginProcess(errorString)
                    }
                })
        })
    }
    
    func textFieldsAreEmpty() -> Bool {
        var result = Bool()
        if emailUITextFieldOutlet.text == "" || passwordUITextFieldOutlet.text == "" {
            result = true
        } else {
            result = false
        }
        return result
    }
    
    func endLoginProcess(errorString: String?) {
        defreezeScreen(true)
        activityIndicatorOutlet.stopAnimating()
        if let _ = errorString {
            displayAlertController(errorString!)
        } else {
            performSegueWithIdentifier(ConstantStrings.sharedInstance.loggedInSuccessfully, sender: nil)
        }
    }
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: ConstantStrings.sharedInstance.signUpUrl)!)
    }
    
    
    
    // MARK: UITextField Delegate
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: Screen behavior
    
    func defreezeScreen(variable: Bool){
        emailUITextFieldOutlet.enabled = variable
        passwordUITextFieldOutlet.enabled = variable
        loginButtonOutlet.enabled = variable
        signupButtonOutlet.enabled = variable
    }
    
    func displayAlertController(errorString: String) {
        let errorAlert = UIAlertController(title: ConstantStrings.sharedInstance.alertControllerTitle, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        errorAlert.addAction(UIAlertAction(title: ConstantStrings.sharedInstance.alertControllerOk, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
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
        
        
        emailUITextFieldOutlet.delegate = self
        passwordUITextFieldOutlet.delegate = self
        emailUITextFieldOutlet.clearButtonMode = .WhileEditing
        passwordUITextFieldOutlet.clearButtonMode = .WhileEditing
        
    }
    

}

