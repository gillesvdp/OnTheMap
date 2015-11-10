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
            var studentInfo100SystemB = [StudentInfo]()
            
            var x = 0
            while x < 100 {
                
                let firstName = parsedResult!["results"]!![x]!["firstName"]!
                let lastName = parsedResult!["results"]!![x]!["lastName"]!
                let latitude = parsedResult!["results"]!![x]!["latitude"]!
                let longitude = parsedResult!["results"]!![x]!["longitude"]!
                let mapString = parsedResult!["results"]!![x]!["mapString"]!
                let mediaURL = parsedResult!["results"]!![x]!["mediaURL"]!

                
                let studentInfo = ["firstName": firstName!, "lastName": lastName!, "latitude": latitude!, "longitude": longitude!, "mapString": mapString!, "mediaURL": mediaURL!]
                let studentInfoSystemB = StudentInfo(initDictionary: studentInfo)
                
                studentInfo100.append(studentInfo)
                studentInfo100SystemB.append(studentInfoSystemB)
                
                x += 1
            }
            // Using NSUserDefaults
            defaults.setObject(studentInfo100, forKey: "studentInfo100")
            
            // Using Singleton (not main data system in the app yet)
            let dataBuffer = DataBuffer()
            dataBuffer.studentsInfo = studentInfo100SystemB
            print(dataBuffer.studentsInfo)
            
            completionHandler(success: true, errorString: nil)
    }
    
    func studentInfoToPost(data: [String: AnyObject],
        completionHandler: (success: Bool, dataInJSonFormat: AnyObject, errorString: String?) -> Void) {
            
            let studentInfoToPostConvertedToJSON = try? NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
            
            completionHandler(success: true, dataInJSonFormat: studentInfoToPostConvertedToJSON!, errorString: nil)
            
    }
    
}

