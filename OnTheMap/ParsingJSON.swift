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
            
            if let firstName = parsedResult!["user"]!!["first_name"] as? String {
                if let lastName = parsedResult!["user"]!!["last_name"] as? String {
                    
                    let firstName = parsedResult!["user"]!!["first_name"] as! String
                    let lastName = parsedResult!["user"]!!["last_name"] as! String
                    let fullName = firstName + " " + lastName
                    defaults.setValue(fullName, forKey: "userFullName")
                    completionHandler(success: true, errorString: nil)
                } else {
                    // Could parse the first name but not the last name
                    completionHandler(success: false, errorString: "Try again or Contact the system administrator")
                }
            } else {
                // Could not parse the first name
                completionHandler(success: false, errorString: "Try again or Contact the system administrator")
            }
            

    }
}

