//
//  PostInformationViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit
import MapKit

class PostInformationViewController: UIViewController, UITextFieldDelegate {

    let topViewLabelText1 = "Where are you studying today?"
    let topViewLabelText2 = "Enter a link to your profile: "
    
    let topTextFieldText1 = "http://www.yourWebsite.com"
    let centerTextFieldText1 = "City, Country"
    
    let bottomViewButtonText1 = "   Search   "
    let bottomViewButtonText2 = "   Confirm   "
    
    var parseApi = ParseAPI()
    var parsingJson = ParsingJSON()
    var places = [CLPlacemark]()
    var mediaURL = String()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var centerViewOutlet: UILabel!
    @IBOutlet weak var bottomViewOutlet: UIView!
    @IBOutlet weak var changeLocationButtunOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var topViewLabelOutlet: UILabel!
    @IBOutlet weak var topViewTextFieldOutlet: UITextField!
    @IBOutlet weak var checkLinkButtonOutlet: UIButton!
    @IBOutlet weak var centerViewTextFieldOutlet: UITextField!
    @IBOutlet weak var bottomViewButtonOutlet: UIButton!
    
    @IBAction func bottomViewButtonPressed(sender: AnyObject) {
        if bottomViewButtonOutlet.currentTitle == bottomViewButtonText1 {
            activityIndicatorOutlet.startAnimating()
            defreezeScreen(false)
            
            // Looking for a location
            let location = centerViewTextFieldOutlet.text
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(location!,
                completionHandler: {(geocodedPlaces: [CLPlacemark]?, geocodingError: NSError?) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.activityIndicatorOutlet.stopAnimating()
                        self.defreezeScreen(true)
                        
                        if let _ = geocodingError {
                            self.displayAlertController("Try again by typing the name of a City, State, or Country.")
                            
                        } else {

                            self.activityIndicatorOutlet.stopAnimating()
                            self.defreezeScreen(true)
                            self.places = geocodedPlaces!
                            
                            self.topViewLabelOutlet.text = self.topViewLabelText2
                            self.topViewTextFieldOutlet.hidden = false
                            self.centerViewTextFieldOutlet.hidden = true
                            self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(geocodedPlaces![0].location!.coordinate, 30000, 30000), animated: true)
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = geocodedPlaces![0].location!.coordinate
                            annotation.title = (DataBuffer.sharedInstance.currentUserFirstName + " " + DataBuffer.sharedInstance.currentUserLastName)
                            
                            annotation.subtitle = self.places[0].country!
                            
                            self.mapView.addAnnotation(annotation)
                            
                            self.mapView.hidden = false
                            self.changeLocationButtunOutlet.hidden = false
                            self.bottomViewButtonOutlet.setTitle(self.bottomViewButtonText2, forState: .Normal)
                        }
                    })
            })
        } else if bottomViewButtonOutlet.currentTitle == bottomViewButtonText2 {
            
            if topViewTextFieldOutlet.text == topTextFieldText1 {
                displayAlertController("Please enter the url of your personal profile or website")
            } else {
            
                // Posting the location
                let uniqueKey = "1234567890" // Not actual key
                let firstName = DataBuffer.sharedInstance.currentUserFirstName
                let lastName = DataBuffer.sharedInstance.currentUserLastName
                let mapString = places[0].locality! + ", " + places[0].country!
                let mediaURL = topViewTextFieldOutlet.text!
                let latitude = places[0].location!.coordinate.latitude
                let longitude = places[0].location!.coordinate.longitude

                let studentInfoToPost = [
                    "uniqueKey": uniqueKey,
                    "firstName": firstName,
                    "lastName" : lastName,
                    "mapString": mapString,
                    "mediaURL" : mediaURL,
                    "latitude" : latitude,
                    "longitude": longitude
                ]
                
                parsingJson.studentInfoToPost(studentInfoToPost as! [String : AnyObject],
                    completionHandler: {(success, dataInJsonFormat, errorString) -> Void in
                    
                        
                        self.parseApi.postStudentLocation(dataInJsonFormat as! NSData,
                            completionHandler: {(success, errorString) -> Void in
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    if success {
                                        self.performSegueWithIdentifier("backToNavigationView", sender: self)
                                    } else {
                                        self.displayAlertController("Connectivity error: try again")
                                    }
                                })
                        })
                })
            }
        }
    }
                        
    
    
    @IBAction func changeLocationButtonPressed(sender: AnyObject) {
        self.mapView.removeAnnotations(mapView.annotations)
        freshScreenSetUp()
    }
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("backToNavigationView", sender: self)
    }
    
    
    @IBAction func checkLinkButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: topViewTextFieldOutlet.text!)!)
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topViewTextFieldOutlet {
            checkLinkButtonOutlet.hidden = false
            if textField.text == topTextFieldText1 {
                textField.text = "http://www."
            }
        }
        if textField == centerViewTextFieldOutlet {
            if textField.text == centerTextFieldText1 {
                textField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == topViewTextFieldOutlet {
            //checkLinkButtonOutlet.hidden = false
            if textField.text == "http://www." || textField.text == "" {
                textField.text = topTextFieldText1
            }
        }
        
        if textField.text == centerTextFieldText1 {
            if textField.text == "" {
                textField.text = centerTextFieldText1
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    func displayAlertController(errorString: String) {
        let errorAlert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
    }
    
    func freshScreenSetUp(){
        changeLocationButtunOutlet.hidden = true
        mapView.hidden = true
        topViewLabelOutlet.text = topViewLabelText1
        topViewTextFieldOutlet.hidden = true
        topViewTextFieldOutlet.text = topTextFieldText1
        checkLinkButtonOutlet.hidden = true
        
        centerViewTextFieldOutlet.hidden = false
        centerViewTextFieldOutlet.text = centerTextFieldText1
        bottomViewButtonOutlet.setTitle(bottomViewButtonText1, forState: .Normal)
        activityIndicatorOutlet.stopAnimating()
    }
    
    func defreezeScreen(variable: Bool){
        bottomViewButtonOutlet.enabled = variable
        centerViewTextFieldOutlet.enabled = variable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topViewTextFieldOutlet.delegate = self
        centerViewTextFieldOutlet.delegate = self
        
        freshScreenSetUp()
    }
}
