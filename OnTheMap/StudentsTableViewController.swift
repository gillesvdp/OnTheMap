//
//  studentsTableViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {

    let defaults = NSUserDefaults()
    var studentInfo100 = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentInfo100 = defaults.valueForKey("studentInfo100") as! [[String: AnyObject]]
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInfo100.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        
        // cell.imageView?.image = UIImage(named: "pin")
        
        let firstName = studentInfo100[indexPath.row]["firstName"] as! String
        let lastName = studentInfo100[indexPath.row]["lastName"] as! String
        
        cell.textLabel?.text = firstName + " " + lastName
        cell.detailTextLabel?.text = studentInfo100[indexPath.row]["mapString"] as? String
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentURL = studentInfo100[indexPath.row]["mediaURL"] as! String
        UIApplication.sharedApplication().openURL(NSURL(string: studentURL)!)
        
    }
}
