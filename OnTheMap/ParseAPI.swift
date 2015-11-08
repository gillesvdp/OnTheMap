//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Gilles on 11/8/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class ParseAPI {

    let defaults = NSUserDefaults()
    let parsingJson = ParsingJSON()
    
    func getStudentLocations(
        completionHandler: (success: Bool, errorString: String?) -> Void ) {
            
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            data, response, downloadError in
            
            if let error = downloadError { 
                completionHandler(success: false, errorString: "Connectivity error: try again")
                
            } else {
                self.parsingJson.studentInfo100(data!, completionHandler: completionHandler)
            }
        }
        task.resume()
    }
    
    func postStudentLocation(studentInfoToPost: [String: AnyObject],
        completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let uniqueKey = studentInfoToPost["uniqueKey"]
        let firstName = studentInfoToPost["firstName"]
        let lastName = studentInfoToPost["lastName"]
        let mapString = studentInfoToPost["mapString"]
        let mediaURL = studentInfoToPost["mediaUrl"]
        let latitude = studentInfoToPost["latitude"]
        let longitute = studentInfoToPost["longitute"]
            
            
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        
        request.HTTPMethod = "POST"
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitute)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, postingError in
            
            if let error = postingError {
                
                completionHandler(success: false, errorString: "Connectivity error: try again")
                
            } else {
            
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                completionHandler(success: true, errorString: nil)
            }
            
        }
        
        task.resume()
    }
}