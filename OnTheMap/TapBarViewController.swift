//
//  TapBarViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/7/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit

class TapBarViewController: UITabBarController {

    let udacityAPI = UdacityAPI()

    @IBOutlet weak var logOutButtonOutlet: UIButton!
    
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        udacityAPI.logOut { (success, errorString) -> Void in
            
            self.logOutButtonOutlet.enabled = false
            
            if let error = errorString {
                // There was an error logging out
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("loggedOut", sender: nil)
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}