//
//  JSONParsing.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class ParsingJSON {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    func userKey(data: NSData,
        completionHandler: (success: Bool, errorString: String?) -> Void) {
            
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
            
            let parsedResult: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            
            let firstName = parsedResult!["user"]!!["first_name"] as! String
            let lastName = parsedResult!["user"]!!["last_name"] as! String
            defaults.setValue(firstName, forKey: "firstName")
            defaults.setValue(lastName, forKey: "lastName")
            
            completionHandler(success: true, errorString: nil)
    }
    
    func studentInfo100(data: NSData,
        completionHandler: (success: Bool, errorString: String?) -> Void) {
    
            let parsedResult: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            
            var studentInfo100 = [[String: AnyObject]]()
            
            var x = 0
            while x < 100 {
                let firstName = parsedResult!["results"]!![x]!["firstName"]!
                let lastName = parsedResult!["results"]!![x]!["lastName"]!
                let latitude = parsedResult!["results"]!![x]!["latitude"]!
                let longitude = parsedResult!["results"]!![x]!["longitude"]!
                let mapString = parsedResult!["results"]!![x]!["mapString"]!
                let mediaURL = parsedResult!["results"]!![x]!["mediaURL"]!
                
                let studentInfo:[String: AnyObject] = ["firstName": firstName!, "lastName": lastName!, "latitude": latitude!, "longitude": longitude!, "mapString": mapString!, "mediaURL": mediaURL!]
                
                studentInfo100.append(studentInfo)
                
                x += 1
            }
            
            defaults.setObject(studentInfo100, forKey: "studentInfo100")
            completionHandler(success: true, errorString: nil)
            
    }
}

