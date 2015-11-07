//
//  JSONParsing.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

func JSONParsingPost(data: NSData,
    completionHandler: (success: Bool, errorString: NSError?) -> Void) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var parsingError: NSError? = nil
        let parsedResult: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        
        if let error = parsingError {
            completionHandler(success: false, errorString: error)
            
        } else {
            defaults.setValue(parsedResult!["account"]!!["key"] as! String, forKey: "userKey")
            completionHandler(success: true, errorString: nil)
        }
        
}

