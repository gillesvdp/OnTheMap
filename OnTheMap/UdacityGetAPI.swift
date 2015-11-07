//
//  UdacityGetAPI.swift
//  OnTheMap
//
//  Created by Gilles on 11/7/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class UdacityGetAPI {
    
    func getUserName(userID: String,
        completionHandler: (success: Bool, errorString: NSError?) -> Void ) {
            
            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userID)")!)
            
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