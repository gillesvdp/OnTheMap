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
            
            do {
                let parsedResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                
                if let _ = parsedResult["status"] as? Int {
                    //The key "status" appears when there is an email/pwd problem
                    completionHandler(success: false, errorString: ConstantStrings.sharedInstance.emailPwdError)
                    
                } else {
                    DataBuffer.sharedInstance.currentUserKey = parsedResult["account"]!!["key"] as! String
                    completionHandler(success: true, errorString: nil)
                }
            } catch _ as NSError {
                completionHandler(success: false, errorString: ConstantStrings.sharedInstance.parsingError)
            }
    }
    
    func userFullName(data: NSData,
        completionHandler: (success: Bool, errorString: String?) -> Void) {
            do {
                let parsedResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            
                let firstName = parsedResult["user"]!!["first_name"] as! String
                let lastName = parsedResult["user"]!!["last_name"] as! String
                DataBuffer.sharedInstance.currentUserFirstName = firstName
                DataBuffer.sharedInstance.currentUserLastName = lastName
                
                completionHandler(success: true, errorString: nil)
                
            } catch _ as NSError {
                completionHandler(success: false, errorString: ConstantStrings.sharedInstance.parsingError)
            }
    }
    
    func studentInfo100(data: NSData,
        completionHandler: (success: Bool, errorString: String?) -> Void) {
    
            
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
                
                DataBuffer.sharedInstance.studentsInfo = studentInfo100
                completionHandler(success: true, errorString: nil)
                
            } else {
                completionHandler(success: false, errorString: ConstantStrings.sharedInstance.parsingError)
            }
    }
    
    func studentInfoToPost(data: [String: AnyObject],
        completionHandler: (success: Bool, dataInJSonFormat: AnyObject?, errorString: String?) -> Void) {
            
            do {
                let studentInfoToPostConvertedToJSON = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
                
                completionHandler(success: true, dataInJSonFormat: studentInfoToPostConvertedToJSON, errorString: nil)
                
            } catch _ as NSError {
                completionHandler(success: false, dataInJSonFormat: nil, errorString: ConstantStrings.sharedInstance.parsingError)
            }
    }
    
}

