//
//  JSONParsingGet.swift
//  OnTheMap
//
//  Created by Gilles on 11/7/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

func JSONParsingGet(data: NSData,
    completionHandler: (success: Bool, errorString: NSError?) -> Void) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var parsingError: NSError? = nil
        let parsedResult: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        
        if let error = parsingError {
            completionHandler(success: false, errorString: error)
            
        } else {
            let firstName = parsedResult!["user"]!!["first_name"] as! String
            let lastName = parsedResult!["user"]!!["last_name"] as! String
            let fullName = firstName + " " + lastName
            defaults.setValue(fullName, forKey: "userFullName")
            completionHandler(success: true, errorString: nil)
        }
        
}
