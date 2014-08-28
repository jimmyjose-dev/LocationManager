//
//  ViewController.swift
//  LocationManagerDemo
//
//  Created by Jimmy Jose on 28/08/14.
//  Copyright (c) 2014 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

import UIKit
import MapKit


enum ServiceType:Int{
    
    case kGoogle = 0
    case kApple
}

enum CallType:Int{
    
    case kDelegate = 0
    case kClosure
}

class ViewController: UIViewController ,LocationManagerDelegate,UITextFieldDelegate{
    
    @IBOutlet var mapView:MKMapView? = MKMapView()
    @IBOutlet var textfield:UITextField? = UITextField()
    
    
    var locationManager = LocationManager.sharedInstance
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var address = "1 Infinite Loop, CA, USA"
        
        textfield?.delegate = self
        textfield?.text = address
        
    }
    
    @IBAction func reverseGeocode(sender:UIButton){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
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
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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
            }else{
                
                self.plotPlacemarkOnMap(placemark)
                
            }
        }
    }
    
    
    func plotOnMapWithAddress(address:NSString){
        
        locationManager.geocodeAddressString(address: address) { (geocodeInfo,placemark, error) -> Void in
            
            if(error != nil){
                
                println(error)
            }else{
                
                self.plotPlacemarkOnMap(placemark)
                
            }
        }
    }
    
    
    
    func plotOnMapWithCoordinates(#latitude: Double, longitude: Double){
        
        locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude) { (reverseGeocodeInfo, placemark, error) -> Void in
            
            if(error != nil){
                
                println(error)
            }else{
                
                self.plotPlacemarkOnMap(placemark)
            }
            
        }
        
    }
    
    func plotPlacemarkOnMap(placemark:CLPlacemark?){
        
        var latDelta:CLLocationDegrees = 0.1
        var longDelta:CLLocationDegrees = 0.1
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(placemark!.location.coordinate, 100, 100)
        self.mapView?.region = theRegion
        self.mapView?.setRegion(theRegion, animated: true)
        self.mapView?.addAnnotation(MKPlacemark(placemark: placemark))
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }
    
    
}
