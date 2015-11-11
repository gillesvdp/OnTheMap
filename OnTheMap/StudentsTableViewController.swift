//
//  studentsTableViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {

    var studentInfo100 = [StudentInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentInfo100 = DataBuffer.sharedInstance.studentsInfo
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataWasRefreshed", name: "dataRefreshed", object: nil)
    }
    
    func dataWasRefreshed() {
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInfo100.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let firstName = studentInfo100[indexPath.row].firstName
        let lastName = studentInfo100[indexPath.row].lastName
        
        cell.textLabel?.text = firstName! + " " + lastName!
        cell.detailTextLabel?.text = studentInfo100[indexPath.row].mapString
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentURL = studentInfo100[indexPath.row].mediaURL
        UIApplication.sharedApplication().openURL(NSURL(string: studentURL!)!)
        
    }
}
