//
//  ConstantString.swift
//  OnTheMap
//
//  Created by Gilles on 11/11/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import Foundation

class ConstantStrings {
    
    static var sharedInstance = ConstantStrings()
    
    // MARK: Udacity API
    let UdacityApiBaseUrl = "https://www.udacity.com/api/"
    let signUpUrl = "https://www.udacity.com/account/auth#!/signup"
    
    // MARK: Parse API
    let ParseApiBaseUrl = "https://api.parse.com/1/classes/StudentLocation"
    let ParseApplicationKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let ParseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    // MARK: Segues
    let loggedInSuccessfully = "loggedInSuccessfully"
    let loggedOutSuccessfully = "loggedOutSuccessfully"
    let goToPostInformationViewController = "goToPostInformationViewController"
    let backToNavigationView = "backToNavigationView"
    
    // MARK: Notification Center
    let dataRefreshed = "dataRefreshed"
    
    // MARK: Error messages
    let alertControllerTitle = "Error"
    let alertControllerOk = "Ok"
    let emptyFields = "Please enter your email and password"
    let emailPwdError = "Incorrect email or password"
    let networkError = "Check your network connection"
    let parsingError = "Please try again or contact the support team if the error persists"
}