//
//  ViewController.swift
//  LocationManagerDemo
//
//  Created by Jimmy Jose on 28/08/14.
//  Copyright (c) 2014 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController ,LocationManagerDelegate,UITextFieldDelegate{
    
    @IBOutlet var mapView:MKMapView? = MKMapView()
    @IBOutlet var textfield:UITextField? = UITextField()
    
    var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
    
    var locationManager = LocationManager.sharedInstance
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.color = UIColor.blueColor()
        //activityIndicator.backgroundColor = UIColor.brownColor()
        
        locationManager.autoUpdate = true
        
        var address = "1 Infinite Loop, CA, USA"
        
        textfield?.delegate = self
        textfield?.text = address
        
    }
    
    @IBAction func reverseGeocode(sender:UIButton){
        
        
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        if (sender.tag == 0){
            
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
        }
        else{
            
            locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
                
                if(error != nil){
                    println(error)
                }else{
                    self.plotOnMapWithCoordinates(latitude: latitude, longitude: longitude)
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func geocode(sender:UIButton){
        
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        var address = textfield?.text!
        textfield?.resignFirstResponder()
        
        if (sender.tag == 0){
            plotOnMapUsingGoogleWithAddress(address!)
        }
        else{
            plotOnMapWithAddress(address!)
        }
        
    }
    
    
    
    func locationManagerStatus(status:NSString){
        
        println(status)
    }
    
    
    func locationManagerReceivedError(error:NSString){
        
        println(error)
        activityIndicator.stopAnimating()
        
    }
    
    
    
    func locationFound(latitude:Double, longitude:Double){
        
        self.plotOnMapWithCoordinates(latitude: latitude, longitude: longitude)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        
        textfield?.resignFirstResponder()
        
        return true
        
    }
    
    func plotOnMapUsingGoogleWithAddress(address:NSString){
        
        locationManager.geocodeUsingGoogleAddressString(address: address) { (geocodeInfo,placemark, error) -> Void in
            
            if(error != nil){
                
                println(error)
                self.activityIndicator.stopAnimating()
            }else{
                
                self.plotPlacemarkOnMap(placemark)
                
            }
        }
    }
    
    
    func plotOnMapWithAddress(address:NSString){
        
        locationManager.geocodeAddressString(address: address) { (geocodeInfo,placemark, error) -> Void in
            
            if(error != nil){
                
                println(error)
                self.activityIndicator.stopAnimating()
            }else{
                
                self.plotPlacemarkOnMap(placemark)
                
            }
        }
    }
    
    
    
    func plotOnMapWithCoordinates(#latitude: Double, longitude: Double){
        
        locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude) { (reverseGeocodeInfo, placemark, error) -> Void in
            
            if(error != nil){
                
                println(error)
                self.activityIndicator.stopAnimating()
            }else{
                
                self.plotPlacemarkOnMap(placemark)
            }
            
        }
        
    }
    
    func plotPlacemarkOnMap(placemark:CLPlacemark?){
        
        if (self.locationManager.isRunning){
            self.locationManager.stopUpdatingLocation()
            self.activityIndicator.removeFromSuperview()
            self.activityIndicator.stopAnimating()
        }
        
        var latDelta:CLLocationDegrees = 0.1
        var longDelta:CLLocationDegrees = 0.1
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        var latitudinalMeters = 100.0
        var longitudinalMeters = 100.0
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(placemark!.location.coordinate, latitudinalMeters, longitudinalMeters)
        self.mapView?.region = theRegion
        self.mapView?.setRegion(theRegion, animated: true)
        
        self.mapView?.addAnnotation(MKPlacemark(placemark: placemark))
        
        
    }
    
}
