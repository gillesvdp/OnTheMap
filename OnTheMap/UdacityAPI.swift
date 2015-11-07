//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class UdacityAPI {
    
    // Login function
    func getUserKey(email: String, password: String,
        completionHandler: (success: Bool, errorString: NSError?) -> Void ) {
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(success: false, errorString: downloadError)
                
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                JSONParsingPost(newData, completionHandler: completionHandler)
            }
        }
        task.resume()
    }
    
    
    // Retrieving the user name upon successful login
    func getUserName(userKey: String,
        completionHandler: (success: Bool, errorString: NSError?) -> Void ) {
            
            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userKey)")!)
            
            request.HTTPMethod = "GET"
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request) {
                data, response, downloadError in
                
                if let error = downloadError {
                    completionHandler(success: false, errorString: downloadError)
                    
                } else {
                    let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                    JSONParsingGet(newData, completionHandler: completionHandler)
                }
            }
            task.resume()
    }
}
    