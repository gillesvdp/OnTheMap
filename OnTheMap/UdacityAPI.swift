//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class UdacityAPI {
    
    let jsonParsing = ParsingJSON()
    
    // Login
    func login(email: String, password: String,
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
                print("Error: Check your connection and try again")
                completionHandler(success: false, errorString: downloadError)
                
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                self.jsonParsing.userKey(newData, completionHandler: completionHandler)
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
                    self.jsonParsing.userFullName(newData, completionHandler: completionHandler)
                }
            }
            task.resume()
    }
    
    // Logout
    func logOut(completionHandler: (success: Bool, errorString: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
    
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
        for cookie in (sharedCookieStorage.cookies! as [NSHTTPCookie]) {
    
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    
        }
    
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
    
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response, downloadError in
            
            if let error = downloadError {
                
                // Could not log out
                completionHandler(success: false, errorString: downloadError)
                
            } else {
                // Logged out successfully
                completionHandler(success: true, errorString: nil)
            }
        
        let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
        //print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
        }
        
        task.resume()
    }
}
    