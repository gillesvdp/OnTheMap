//
//  StudentInfoStruct.swift
//  OnTheMap
//
//  Created by Gilles on 11/9/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

struct StudentInfo {
    
    var firstName : String
    var lastName : String
    var latitude : Float
    var longitude: Float
    var mediaURL : String
    var mapString : String
    
    init(initDictionary: [String: AnyObject]) {
        
        firstName = initDictionary["firstName"]! as! String
        lastName = initDictionary["lastName"]! as! String
        latitude = initDictionary["latitude"]! as! Float
        longitude = initDictionary["longitude"]! as! Float
        mediaURL = initDictionary["mediaURL"]! as! String
        mapString = initDictionary["mapString"]! as! String
        
    }
}