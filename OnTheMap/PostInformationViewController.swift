//
//  PostInformationViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit
import MapKit

class PostInformationViewController: UIViewController {

    let topViewLabelText1 = "Where are you studying today?"
    let topViewLabelText2 = "Enter a link to your profile: "
    
    let bottomViewButtonText1 = "   Search   "
    let bottomViewButtonText2 = "   Confirm   "
    
    var parseApi = ParseAPI()
    var defaults = NSUserDefaults()
    var places = [CLPlacemark]()
    var mediaURL = String()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var centerViewOutlet: UILabel!
    @IBOutlet weak var bottomViewOutlet: UIView!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var topViewLabelOutlet: UILabel!
    @IBOutlet weak var centerViewTextFieldOutlet: UITextField!
    @IBOutlet weak var bottomViewButtonOutlet: UIButton!
    
    @IBAction func bottomViewButtonPressed(sender: AnyObject) {
        print(1)
        if bottomViewButtonOutlet.currentTitle == bottomViewButtonText1 {
            print(2)
            
            // Looking for a location
            var location = centerViewTextFieldOutlet.text
            var geocoder = CLGeocoder()
        
            geocoder.geocodeAddressString(location!,
                completionHandler: {(places: [CLPlacemark]?, error: NSError?) -> Void in
                
                    dispatch_async(dispatch_get_main_queue(), {
                        if let error = error {
                            print("Try again by typing the name of a City, State, or Country.")
                            
                        } else {
                            self.places = places!
                            print(places![0].locality!)
                            print(places![0].country!)
                            print(places![0].location!.coordinate.latitude)
                            print(places![0].location!.coordinate.longitude)
                            
                            // Updating the screen
                            self.topViewLabelOutlet.text = self.topViewLabelText2
                            self.centerViewTextFieldOutlet.hidden = true
                            self.mapView.hidden = false
                            self.bottomViewButtonOutlet.setTitle(self.bottomViewButtonText2, forState: .Normal)
                        }
                    })
            })
        } else if bottomViewButtonOutlet.currentTitle == bottomViewButtonText2 {
            
            // Posting the location
            let uniqueKey = "1234567890" // Not actual key
            let firstName = defaults.valueForKey("firstName")!
            let lastName = defaults.valueForKey("lastName")!
            let mapString = places[0].locality! + ", " + places[0].country!
            let mediaURL = "http://www.google.com"
            let latitude = places[0].location!.coordinate.latitude
            let longitude = places[0].location!.coordinate.longitude

            var studentInfoToPost = [
                "uniqueKey": uniqueKey,
                "firstName": firstName,
                "lastName" : lastName,
                "mapString": mapString,
                "mediaURL" : mediaURL,
                "latitude" : latitude,
                "longitude": longitude
            ]
            
            print(studentInfoToPost)
            
            let studentInfoToPostConvertedToJSON = try? NSJSONSerialization.dataWithJSONObject(studentInfoToPost, options: NSJSONWritingOptions.PrettyPrinted)
            
            parseApi.postStudentLocation(studentInfoToPostConvertedToJSON!,
                completionHandler: {(success, errorString) -> Void in
                    if success {
                        print("success")
                        // Perform segue to nav controller
                    } else {
                        print("failed")
                    }
                
                })
            
            
        }
    }
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("backToNavigationView", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.hidden = true
        topViewLabelOutlet.text = topViewLabelText1
        bottomViewButtonOutlet.setTitle(bottomViewButtonText1, forState: .Normal)
    }
}
