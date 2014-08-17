//
//  LocationManager.swift
//
//
//  Created by Jimmy Jose on 14/08/14.
//  Copyright (c) 2014 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreLocation


class LocationManager: NSObject,CLLocationManagerDelegate {
    
    
    var delegate:LocationManagerDelegate? = nil
    
    var latitude:String = ""
    var longitude:String = ""
    
    var locationManager: CLLocationManager!
    
    class var sharedInstance : LocationManager {
    struct Static {
        static let instance : LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    
    override init(){
        
        super.init()
        
    }
    
    func start(){
        
        initLocationManager()
    }
    
    func stop(){
        //locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func initLocationManager() {
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //locationManager.requestAlwaysAuthorization()
        //locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if delegate? != nil{
            delegate?.locationManagerReceivedError!(error.localizedDescription)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var arrayOfLocation = locations as NSArray
        var location = arrayOfLocation.lastObject as CLLocation
        var coordLatLon = location.coordinate
        if delegate? != nil{
            delegate?.locationFoundGetAsString!(coordLatLon.latitude.description,longitude: coordLatLon.longitude.description)
            delegate?.locationFound(coordLatLon.latitude,longitude: coordLatLon.longitude)
        }
    }
    
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var hasAuthorised = false
            var locationStatus : NSString = "Calibrating"
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access"
            case CLAuthorizationStatus.Denied:
                locationStatus = "Denied access"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Not determined"
            default:
                locationStatus = "Allowed access"
                hasAuthorised = true
            }
            
            if (hasAuthorised == true) {
                locationManager.startMonitoringSignificantLocationChanges()
                //locationManager.startUpdatingLocation()
            }else{
                
                if (delegate? != nil){
                    delegate?.locationManagerStatus!(locationStatus)
                    
                }
            }
            
    }
}


@objc protocol LocationManagerDelegate : NSObjectProtocol
{
    optional func locationFoundGetAsString(latitude:NSString, longitude:NSString)
    func locationFound(latitude:Double, longitude:Double)
    optional func locationManagerStatus(status:NSString)
    optional func locationManagerReceivedError(error:NSString)
}

