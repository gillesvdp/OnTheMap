//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Gilles on 11/8/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class ParseAPI {

    let parsingJson = ParsingJSON()
    
    func getStudentLocations(
        completionHandler: (data: [StudentInfo]?, errorString: String?) -> Void ) {
            
        let request = NSMutableURLRequest(URL: NSURL(string: ConstantStrings.sharedInstance.ParseApiBaseUrl + "?limit=100&order=-updatedAt")!)
        request.addValue(ConstantStrings.sharedInstance.ParseApplicationKey, forHTTPHeaderField: "X-Parse-Application-Id")
        
        request.addValue(ConstantStrings.sharedInstance.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            data, response, downloadError in
            
            if let _ = downloadError { 
                completionHandler(data: nil, errorString: ConstantStrings.sharedInstance.networkError)
            } else {
                self.parsingJson.studentInfo100(data!, completionHandler: completionHandler)
            }
        }
        task.resume()
    }
    
    func postStudentLocation(studentInfoToPost: NSData,
        completionHandler: (errorString: String?) -> Void) {
            
        let request = NSMutableURLRequest(URL: NSURL(string: ConstantStrings.sharedInstance.ParseApiBaseUrl)!)
        
        request.HTTPMethod = "POST"
        
        request.addValue(ConstantStrings.sharedInstance.ParseApplicationKey, forHTTPHeaderField: "X-Parse-Application-Id")
        
        request.addValue(ConstantStrings.sharedInstance.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = studentInfoToPost
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, postingError in
            
            if let _ = postingError {
                
                completionHandler(errorString: ConstantStrings.sharedInstance.networkError)
                
            } else {
            
                completionHandler(errorString: nil)
            }
            
        }
        
        task.resume()
    }
}