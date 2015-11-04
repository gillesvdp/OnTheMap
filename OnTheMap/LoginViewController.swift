//
//  ViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // Outlets
    
    @IBOutlet weak var loginBackgroundOnlyOutlet: UITextField!
    @IBOutlet weak var passwordBackgroundOnlyOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginBackgroundOnlyOutlet.enabled = false
        passwordBackgroundOnlyOutlet.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

