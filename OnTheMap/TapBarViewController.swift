//
//  TapBarViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/7/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit

class TapBarViewController: UITabBarController {

    let parseApi = ParseAPI()
    let udacityAPI = UdacityAPI()
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var logOutButtonOutlet: UIButton!
    @IBOutlet weak var postInformationButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var refreshButtonOutlet: UIBarButtonItem!
    
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        udacityAPI.logOut { (success, errorString) -> Void in
            
            self.logOutButtonOutlet.enabled = false
            
            if let _ = errorString {
                // There was an error logging out
                self.displayAlertController(errorString!)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    // Emptying NSUSerDefaults
                    self.defaults.removeObjectForKey("userKey")
                    self.defaults.removeObjectForKey("userFullName")
                    
                    // Go back to the login screen
                    self.performSegueWithIdentifier("loggedOut", sender: nil)
                })
            }
        }
    }
    
    @IBAction func postInformationButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("goToPostInformationViewController", sender: self)
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        parseApi.getStudentLocations { (success, errorString) -> Void in
            
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.parseApi.getStudentLocations({ (success, errorString) -> Void in
                        if let _ = errorString {
                            self.displayAlertController(errorString!)
                        } else {
                            self.sendDataNotification("dataRefreshed")
                        }
                    })
                    
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    print(errorString)
                })
            }
        }
    }
    
    private func sendDataNotification(notificationName: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayAlertController(errorString: String) {
        let errorAlert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
    }

}
