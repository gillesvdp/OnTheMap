//
//  JSONParsing.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class ParsingJSON {

    func userKey(data: NSData,
        completionHandler: (success: Bool, errorString: String?) -> Void) {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let parsedResult: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                
            if let emailPwdError = parsedResult!["status"] as? Int {
                //The key "status" appears when there is an email/pwd problem
                completionHandler(success: false, errorString: "Incorrect email or password")
                    
            } else {
                defaults.setValue(parsedResult!["account"]!!["key"] as! String, forKey: "userKey")
                completionHandler(success: true, errorString: nil)
                    
            }
    }
    
    func userFullName(data: NSData,
        completionHandler: (success: Bool, errorString: String?) -> Void) {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let parsedResult: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            let firstName = parsedResult!["user"]!!["first_name"] as! String
            let lastName = parsedResult!["user"]!!["last_name"] as! String
            let fullName = firstName + " " + lastName
            defaults.setValue(fullName, forKey: "userFullName")
            completionHandler(success: true, errorString: nil)
    }
}

