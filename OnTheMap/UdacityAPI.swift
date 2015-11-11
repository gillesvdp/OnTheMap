//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class UdacityAPI {
    
    let parsingJson = ParsingJSON()
    
    // Login
    func login(email: String, password: String,
        completionHandler: (data: String?, errorString: String?) -> Void ) {
    
        let request = NSMutableURLRequest(URL: NSURL(string: ConstantStrings.sharedInstance.UdacityApiBaseUrl + "session")!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            data, response, downloadError in
            
            // Checking for connection errors
            if let _ = downloadError {
                completionHandler(data: nil, errorString: ConstantStrings.sharedInstance.networkError)
            
            // There was no connectivity issue, the data received will be checked.
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                self.parsingJson.userKey(newData, completionHandler: completionHandler)
            }
        }
        task.resume()
    }
    
    
    // Retrieving the user name upon successful login
    func getUserFullName(userKey: String,
        completionHandler: (userFirstName: String?, userLastName: String?, errorString: String?) -> Void ) {
            
            let request = NSMutableURLRequest(URL: NSURL(string: ConstantStrings.sharedInstance.UdacityApiBaseUrl + "users/\(userKey)")!)
            
            request.HTTPMethod = "GET"
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request) {
                data, response, downloadError in
                
                if let _ = downloadError {
                    completionHandler(userFirstName: nil, userLastName: nil, errorString: ConstantStrings.sharedInstance.networkError)
                    
                } else {
                    let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                    self.parsingJson.userFullName(newData, completionHandler: completionHandler)
                }
            }
            task.resume()
    }
    
    // Logout
    func logOut(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: ConstantStrings.sharedInstance.UdacityApiBaseUrl + "session")!)
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
            
            if let _ = downloadError {
                completionHandler(success: false, errorString: ConstantStrings.sharedInstance.networkError)
                
            } else {
                completionHandler(success: true, errorString: nil)
            }
        }
        task.resume()
    }
}
    