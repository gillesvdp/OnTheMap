//
//  studentsTableViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataWasRefreshed", name: ConstantStrings.sharedInstance.dataRefreshed, object: nil)
    }
    
    func dataWasRefreshed() {
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataBuffer.sharedInstance.studentsInfo.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let firstName = DataBuffer.sharedInstance.studentsInfo[indexPath.row].firstName
        let lastName = DataBuffer.sharedInstance.studentsInfo[indexPath.row].lastName
        
        cell.textLabel?.text = firstName! + " " + lastName!
        cell.detailTextLabel?.text = DataBuffer.sharedInstance.studentsInfo[indexPath.row].mapString
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentURL = DataBuffer.sharedInstance.studentsInfo[indexPath.row].mediaURL
        UIApplication.sharedApplication().openURL(NSURL(string: studentURL!)!)
        
    }
}
