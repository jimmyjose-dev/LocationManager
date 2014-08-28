LocationManager
=====================

Location manager is a CLLocationManager wrapper written entirely in Swift
----------------------------------
**Features:**
>  1) Location update with closure & delegate support 
>  
>  2) Geocoding and reverse geocoding using Apple service 
>  
>  3) Geocoding and reverse geocoding using Google service
>
> 4) Closure returns CLPlacemark object, making it easier to place pin on map




Sample code
-----------
***Closure***

**Location update**

    var locationManager = LocationManager.sharedInstance
    locationManager.showVerboseMessage = true
    locationManager.autoUpdate = false
    locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
                
        println("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
        println(verboseMessage)
    }

**Geocoding using Apple service**

    var locationManager = LocationManager.sharedInstance      
    locationManager.geocodeAddressString(address: "Apple Inc., Infinite Loop, Cupertino, CA  95014, United States") { (geocodeInfo,placemark,error) -> Void in
                
                if(error != nil){
                    println(error)
                }else{
                    println(geocodeInfo!)
                }
            }
            

**Reverse Geocoding using Apple service**

    var locationManager = LocationManager.sharedInstance
    locationManager.reverseGeocodeLocationWithLatLon(latitude: 37.331789, longitude: -122.029620) { (reverseGecodeInfo,placemark,error) -> Void in
                
                if(error != nil){
                    println(error)
                }else{
                	println(reverseGecodeInfo!)
                }
                
            }

**Geocoding using Google service**

    var locationManager = LocationManager.sharedInstance
    locationManager.geocodeUsingGoogleAddressString(address: "Apple Inc., Infinite Loop, Cupertino, CA  95014, United States") { (geocodeInfo,placemark,error) -> Void in
                
                if(error != nil){
                	println(error)
                }else{	
                	println(geocodeInfo!)
                }
                
            }


**Reverse Geocoding using Google service**

    var locationManager = LocationManager.sharedInstance
    locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: 37.331789, longitude: -122.029620) { (reverseGecodeInfo,placemark,error) -> Void in
                
                if(error != nil){
                	println(error)
                }else{
                	println(reverseGecodeInfo!)
                }
            }

----------

***Delegate***

**Location update**

    *class ViewController: UIViewController ,LocationManagerDelegate{....*
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var locationManager = LocationManager.sharedInstance
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        
        locationManager.stopUpdatingLocation()
    }
    
     func locationManagerStatus(status:NSString){
        
        println(status)
    }
    
    
    func locationManagerReceivedError(error:NSString){
        
        println(error)
        
    }
    
    func locationFoundGetAsString(latitude: NSString, longitude: NSString) {
       
    }
    
    
    func locationFound(latitude:Double, longitude:Double){
        
    }

----------

Verbose Message based on CLAuthorizationStatus
---------------

 - App is Authorized to use location services.
 
 - You have not yet made a choice with regards to this application.
 
 - This application is not authorized to use location services. Due to
   active restrictions on location services, the user cannot change this
   status, and may not have personally denied authorization.

 - You have explicitly denied authorization for this application, or
   location services are disabled in Settings.

----------

***Add Privacy - Location Usage Description  and NSLocationWhenInUseUsageDescription in your plist***


Roadmap
---------------

 - Compatiblity check for iOS7 & iOS8  
 - iPhone4 and startMonitoringSignificantLocationChanges issue

----------
Contact Us
---------------

Have any questions or suggestions feel free to write at jimmy@varshyl.com (Jimmy Jose)
http://www.varshylmobile.com/

