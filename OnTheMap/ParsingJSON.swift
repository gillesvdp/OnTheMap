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
        completionHandler: (data: String?, errorString: String?) -> Void) {
            
            do {
                let parsedResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                
                if let _ = parsedResult["status"] as? Int {
                    //The key "status" appears when there is an email/pwd problem
                    completionHandler(data: nil, errorString: ConstantStrings.sharedInstance.emailPwdError)
                    
                } else {
                    completionHandler(data: parsedResult["account"]!!["key"] as? String, errorString: nil)
                }
            } catch _ as NSError {
                completionHandler(data: nil, errorString: ConstantStrings.sharedInstance.parsingError)
            }
    }
    
    func userFullName(data: NSData,
        completionHandler: (userFirstName: String?, userLastname: String?, errorString: String?) -> Void) {
            do {
                let parsedResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            
                let firstName = parsedResult["user"]!!["first_name"] as! String
                let lastName = parsedResult["user"]!!["last_name"] as! String
                
                completionHandler(userFirstName: firstName, userLastname: lastName, errorString: nil)
                
            } catch _ as NSError {
                completionHandler(userFirstName: nil, userLastname: nil, errorString: ConstantStrings.sharedInstance.parsingError)
            }
    }
    
    func studentInfo100(data: NSData,
        completionHandler: (data: [StudentInfo]?, errorString: String?) -> Void) {
    
            
            let parsedResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            
            var studentInfo100 = [StudentInfo]()
            
            if let _ = parsedResult["results"]??[0]?["firstName"] {
                
                var x = 0
                while x < 100 {
                    
                    let firstName = parsedResult["results"]!![x]!["firstName"]!
                    let lastName = parsedResult["results"]!![x]!["lastName"]!
                    let latitude = parsedResult["results"]!![x]!["latitude"]!
                    let longitude = parsedResult["results"]!![x]!["longitude"]!
                    let mapString = parsedResult["results"]!![x]!["mapString"]!
                    let mediaURL = parsedResult["results"]!![x]!["mediaURL"]!
                    
                    let studentInfoDictionary = ["firstName": firstName!, "lastName": lastName!, "latitude": latitude!, "longitude": longitude!, "mapString": mapString!, "mediaURL": mediaURL!]
                    let studentInfo = StudentInfo(initDictionary: studentInfoDictionary)
                    
                    studentInfo100.append(studentInfo)
                    
                    x += 1
                }
                
                completionHandler(data: studentInfo100, errorString: nil)
                
            } else {
                completionHandler(data: nil, errorString: ConstantStrings.sharedInstance.parsingError)
            }
    }
    
    func studentInfoToPost(data: [String: AnyObject],
        completionHandler: (dataInJSonFormat: AnyObject?, errorString: String?) -> Void) {
            
            do {
                let studentInfoToPostConvertedToJSON = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
                
                completionHandler(dataInJSonFormat: studentInfoToPostConvertedToJSON, errorString: nil)
                
            } catch _ as NSError {
                
                completionHandler(dataInJSonFormat: nil, errorString: ConstantStrings.sharedInstance.parsingError)
            }
    }
    
}

