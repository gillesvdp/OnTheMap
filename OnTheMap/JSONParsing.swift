//
//  JSONParsing.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

func JSONParsing(data: NSData,
    completionHandler: (success: Bool, errorString: NSError?) -> Void) {
        
        var appDelegate = AppDelegate()
        
        var parsingError: NSError? = nil
        let parsedResult: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        
        if let error = parsingError {
            completionHandler(success: false, errorString: error)
            
        } else {
            print("parsedResult is \(parsedResult!)")
            appDelegate.UdacityUserKey = parsedResult!["account"]!!["key"] as! String
            print(appDelegate.UdacityUserKey)
            completionHandler(success: true, errorString: nil)
        }
        
}

