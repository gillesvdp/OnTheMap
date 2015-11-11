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
                    self.performSegueWithIdentifier(ConstantStrings.sharedInstance.loggedOutSuccessfully, sender: nil)
                })
            }
        }
    }
    
    @IBAction func postInformationButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier(ConstantStrings.sharedInstance.goToPostInformationViewController, sender: self)
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        parseApi.getStudentLocations { (data, errorString) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {
                if let _ = errorString {
                    self.displayAlertController(errorString!)
                } else {
                    DataBuffer.sharedInstance.studentsInfo = data!
                    self.sendDataNotification(ConstantStrings.sharedInstance.dataRefreshed)
                }
            })
        }
    }
    
    private func sendDataNotification(notificationName: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayAlertController(errorString: String) {
        let errorAlert = UIAlertController(title: ConstantStrings.sharedInstance.alertControllerTitle, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        errorAlert.addAction(UIAlertAction(title: ConstantStrings.sharedInstance.alertControllerOk, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
    }

}
