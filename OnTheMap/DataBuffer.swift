//
//  DataBuffer.swift
//  OnTheMap
//
//  Created by Gilles on 11/9/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class DataBuffer {
    
    static var sharedInstance = DataBuffer()
    
    // MARK: Student information to populate the Map and the TableView
    var studentsInfo = [StudentInfo]()
    
    // MARK: Current user information
    var currentUserKey = String()
    var currentUserFirstName = String()
    var currentUserLastName = String()
    
}