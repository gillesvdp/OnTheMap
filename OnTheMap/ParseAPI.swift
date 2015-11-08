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
        completionHandler: (success: Bool, studentInfo100: [[String: AnyObject]]?, errorString: String?) -> Void ) {
            
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            data, response, downloadError in
            
            if let error = downloadError { 
                completionHandler(success: false, studentInfo100: nil, errorString: "Connectivity error: try again")
                
            } else {
                self.parsingJson.studentInfo100(data!, completionHandler: completionHandler)
            }
        }
        task.resume()
    }
}