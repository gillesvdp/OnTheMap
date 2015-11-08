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
            
            if let error = errorString {
                // There was an error logging out
                
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
                    print("refreshed screen")
                    self.viewWillAppear(true)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    print(errorString)
                })
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

}
