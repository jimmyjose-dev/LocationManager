//
//  ViewController.swift
//  LocationManagerDemo
//
//  Created by Jimmy Jose on 28/08/14.
//  Copyright (c) 2014 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, LocationManagerDelegate, UITextFieldDelegate {
  
  @IBOutlet var mapView:MKMapView? = MKMapView()
  @IBOutlet var textfield:UITextField? = UITextField()
  
  var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 50, height: 50)) as UIActivityIndicatorView
  
  var locationManager = LocationManager.sharedInstance
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    activityIndicator.center = self.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
    activityIndicator.color = UIColor.blue
    //activityIndicator.backgroundColor = UIColor.brownColor()
    
    locationManager.autoUpdate = true
    
    let address = "1 Infinite Loop, CA, USA"
    
    textfield?.delegate = self
    textfield?.text = address
  }
  
  @IBAction func reverseGeocode(_ sender:UIButton) {
    
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
    
    if sender.tag == 0 {
      
      locationManager.delegate = self
      locationManager.startUpdatingLocation()
    } else{
      
      locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
        
      if error != nil {
          print(error)
      } else {
          self.plotOnMapWithCoordinates(latitude, longitude)
        }
      }
    }
  }
  
  @IBAction func geocode(_ sender:UIButton) {
    
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
    let address = textfield?.text!
    textfield?.resignFirstResponder()
    
    if sender.tag == 0 {
      plotOnMapUsingGoogleWithAddress(address! as NSString)
    } else {
      plotOnMapWithAddress(address! as NSString)
    }
  }
  
  func locationManagerStatus(_ status:NSString) {

    print(status)
  }
  
  func locationManagerReceivedError(_ error:NSString) {
    
    print(error)
    activityIndicator.stopAnimating()
  }
  
  func locationFound(_ latitude:Double, longitude:Double) {
    
    self.plotOnMapWithCoordinates(latitude, longitude)
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textfield?.resignFirstResponder()
    
    return true
  }
  
  func plotOnMapUsingGoogleWithAddress(_ address:NSString) {
    
    locationManager.geocodeUsingGoogleAddressString(address: address) { (geocodeInfo,placemark, error) -> Void in
      
      self.performActionWithPlacemark(placemark, error: error)
    }
  }
  
  func plotOnMapWithAddress(_ address:NSString) {
    
    locationManager.geocodeAddressString(address: address) { (geocodeInfo,placemark, error) -> Void in
      
      self.performActionWithPlacemark(placemark, error: error)        }
  }
  
  func plotOnMapWithCoordinates(_ latitude: Double, _ longitude: Double) {
    
    locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude) { (reverseGeocodeInfo, placemark, error) -> Void in
      
      self.performActionWithPlacemark(placemark, error: error)
    }
  }
  
  
  func performActionWithPlacemark(_ placemark:CLPlacemark?,error:String?) {
    
    if error != nil {
      
      print(error)
      
      (DispatchQueue.main).async(execute: { () -> Void in
        
        if self.activityIndicator.superview != nil {
  
          self.activityIndicator.stopAnimating()
          self.activityIndicator.removeFromSuperview()
        }
      })
    } else {
      DispatchQueue.main.async(execute: { () -> Void in
        self.plotPlacemarkOnMap(placemark)
      })
    }
  }
  
  func removeAllPlacemarkFromMap(_ shouldRemoveUserLocation:Bool) {
    
    if let mapView = self.mapView {
      for annotation in mapView.annotations{
        if shouldRemoveUserLocation {
          if annotation as? MKUserLocation !=  mapView.userLocation {
            mapView.removeAnnotation(annotation )
          }
        }
      }
    }
  }
  
  func plotPlacemarkOnMap(_ placemark:CLPlacemark?) {
    
    removeAllPlacemarkFromMap(true)
    
    if self.locationManager.isRunning {
      self.locationManager.stopUpdatingLocation()
    }
    
    if self.activityIndicator.superview != nil {
      
      self.activityIndicator.stopAnimating()
      self.activityIndicator.removeFromSuperview()
    }
    
    let latDelta:CLLocationDegrees = 0.1
    let longDelta:CLLocationDegrees = 0.1
    var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
    
    let latitudinalMeters = 100.0
    let longitudinalMeters = 100.0
    let theRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(placemark!.location!.coordinate, latitudinalMeters, longitudinalMeters)
    
    self.mapView?.setRegion(theRegion, animated: true)
    
    self.mapView?.addAnnotation(MKPlacemark(placemark: placemark!))
  }
}
