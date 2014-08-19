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
    
    var completionHandler:((latitude:Double, longitude:Double, status:String, verboseMessage:String, error:String?)->())?
    
    var locationStatus : NSString = "Calibrating"// to pass in handler
    
    
    var delegate:LocationManagerDelegate? = nil
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    var latitudeAsString:String = ""
    var longitudeAsString:String = ""
    
    
    var lastKnownLatitude:Double = 0.0
    var lastKnownLongitude:Double = 0.0
    
    var lastKnownLatitudeAsString:String = ""
    var lastKnownLongitudeAsString:String = ""
    
    
    var keepLastKnownLocation:Bool = true
    var hasLastKnownLocation:Bool = true
    
    var autoUpdate:Bool = false
    
    var locationManager: CLLocationManager!
    
    var showVerboseMessage = false
    
    
    private var verboseMessage = "Calibrating"
    
    private let verboseMessageDictionary = [CLAuthorizationStatus.NotDetermined:"You have not yet made a choice with regards to this application.",
        CLAuthorizationStatus.Restricted:"This application is not authorized to use location services. Due to active restrictions on location services, the user cannot change this status, and may not have personally denied authorization.",
        CLAuthorizationStatus.Denied:"You have explicitly denied authorization for this application, or location services are disabled in Settings.",
        CLAuthorizationStatus.Authorized:"App is Authorized to use location services.",CLAuthorizationStatus.AuthorizedWhenInUse:"You have granted authorization to use your location only when the app is visible to you."]
    
    
    class var sharedInstance : LocationManager {
    struct Static {
        static let instance : LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    
    
    private override init(){
        
        super.init()
        
        if(!autoUpdate){
            autoUpdate = !CLLocationManager.significantLocationChangeMonitoringAvailable()
        }
        
    }
    
    private func resetLatLon(){
        
        latitude = 0.0
        longitude = 0.0
        
        latitudeAsString = ""
        longitudeAsString = ""
        
    }
    
    private func resetLastKnownLatLon(){
        
        hasLastKnownLocation = false
        
        lastKnownLatitude = 0.0
        lastKnownLongitude = 0.0
        
        lastKnownLatitudeAsString = ""
        lastKnownLongitudeAsString = ""
        
    }
    
    func startUpdatingLocation(completionHandler:((latitude:Double, longitude:Double, status:String, verboseMessage:String, error:String?)->())? = nil){
        
        self.completionHandler = completionHandler
        
        initLocationManager()
    }
    
    
    func startUpdatingLocation(){
        
        initLocationManager()
    }
    
    func stopUpdatingLocation(){
        if(autoUpdate){
            locationManager.stopUpdatingLocation()
        }else{
            
            locationManager.stopMonitoringSignificantLocationChanges()
        }
        
        
        resetLatLon()
        if(!keepLastKnownLocation){
            resetLastKnownLatLon()
        }
    }
    
    private func initLocationManager() {
        
        // App might be unreliable if someone changes autoupdate status in between and stops it
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //check for iOS8 thingy in next update
        //locationManager.requestAlwaysAuthorization()
        
        if(autoUpdate){
            
            locationManager.startUpdatingLocation()
        }else{
            
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
        
    }
    
    
    internal func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        locationManager.stopUpdatingLocation()
        resetLatLon()
        if(!keepLastKnownLocation){
            
            resetLastKnownLatLon()
        }
        
        var verbose = ""
        if showVerboseMessage {verbose = verboseMessage}
        completionHandler?(latitude: 0.0, longitude: 0.0, status: locationStatus, verboseMessage:verbose,error: error.localizedDescription)
        
        if ((delegate? != nil) && (delegate?.respondsToSelector(Selector("locationManagerReceivedError:")))!){
            delegate?.locationManagerReceivedError!(error.localizedDescription)
        }
    }
    
    internal func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var arrayOfLocation = locations as NSArray
        var location = arrayOfLocation.lastObject as CLLocation
        var coordLatLon = location.coordinate
        
        latitude  = coordLatLon.latitude
        longitude = coordLatLon.longitude
        
        latitudeAsString  = coordLatLon.latitude.description
        longitudeAsString = coordLatLon.longitude.description
        
        var verbose = ""
        if showVerboseMessage {verbose = verboseMessage}
        completionHandler?(latitude: latitude, longitude: longitude, status: locationStatus,verboseMessage:verbose, error: nil)
        
        lastKnownLatitude = coordLatLon.latitude
        lastKnownLongitude = coordLatLon.longitude
        
        lastKnownLatitudeAsString = coordLatLon.latitude.description
        lastKnownLongitudeAsString = coordLatLon.longitude.description
        
        hasLastKnownLocation = true
        
        if (delegate? != nil){
            if((delegate?.respondsToSelector(Selector("locationFoundGetAsString:longitude:")))!){
                delegate?.locationFoundGetAsString!(latitudeAsString,longitude:longitudeAsString)
            }
            if((delegate?.respondsToSelector(Selector("locationFound:longitude:")))!){
                delegate?.locationFound(latitude,longitude:longitude)
            }
        }
    }
    
    
    internal func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var hasAuthorised = false
            var verboseKey = status
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
            
            verboseMessage = verboseMessageDictionary[verboseKey]!
            
            if (hasAuthorised == true) {
                if(autoUpdate){
                    
                    locationManager.startUpdatingLocation()
                }else{
                    
                    locationManager.startMonitoringSignificantLocationChanges()
                }
            }else{
                
                resetLatLon()
                if (!locationStatus.isEqualToString("Denied access")){
                    
                    var verbose = ""
                    if showVerboseMessage {
                        
                        verbose = verboseMessage
                        
                        if ((delegate? != nil) && (delegate?.respondsToSelector(Selector("locationManagerVerboseMessage:")))!){
                        
                            delegate?.locationManagerVerboseMessage!(verbose)
                        
                        }
                    }
                    completionHandler?(latitude: latitude, longitude: longitude, status: locationStatus, verboseMessage:verbose,error: nil)
                }
                if ((delegate? != nil) && (delegate?.respondsToSelector(Selector("locationManagerStatus:")))!){
                    delegate?.locationManagerStatus!(locationStatus)
                }
            }
            
    }
}


@objc protocol LocationManagerDelegate : NSObjectProtocol
{
    func locationFound(latitude:Double, longitude:Double)
    optional func locationFoundGetAsString(latitude:NSString, longitude:NSString)
    optional func locationManagerStatus(status:NSString)
    optional func locationManagerReceivedError(error:NSString)
    optional func locationManagerVerboseMessage(message:NSString)
}

