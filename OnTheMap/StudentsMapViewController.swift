//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Gilles on 11/4/15.
//  Copyright © 2015 gillesvdp. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: UIViewController, MKMapViewDelegate {

    let parseApi = ParseAPI()
    let defaults = NSUserDefaults()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataWasRefreshed", name: ConstantStrings.sharedInstance.dataRefreshed, object: nil)
        
        parseApi.getStudentLocations { (data, errorString) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if let _ = errorString {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.displayAlertController(errorString!)
                        
                    })
                } else {
                    DataBuffer.sharedInstance.studentsInfo = data!
                    self.displayStudentInfo100OnMap()
                }
            })
        }
    }
    
    func dataWasRefreshed() {
        displayStudentInfo100OnMap()
    }
    
    func displayStudentInfo100OnMap() {
        let locations = DataBuffer.sharedInstance.studentsInfo 
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locations {
            let lat = CLLocationDegrees(dictionary.latitude! )
            let long = CLLocationDegrees(dictionary.longitude! )
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = dictionary.firstName
            let lastName = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    func displayAlertController(errorString: String) {
        let errorAlert = UIAlertController(title: ConstantStrings.sharedInstance.alertControllerTitle, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        errorAlert.addAction(UIAlertAction(title: ConstantStrings.sharedInstance.alertControllerOk, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
    }
    
}
