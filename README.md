LocationManager
=====================

CLLocationManager wrapper in Swift, performs location update, geocoding and reverse geocoding with both Apple and Google service

Closure

    completionHandler:((latitude:Double, longitude:Double, status:String, verboseMessage:String, error:String?)


----------


Delegates in LocationManager

	func locationFound(latitude:Double, longitude:Double)
    optional func locationFoundGetAsString(latitude:NSString, longitude:NSString)
    optional func locationManagerStatus(status:NSString)
    optional func locationManagerReceivedError(error:NSString)
    optional func locationManagerVerboseMessage(message:NSString)
    
 


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


Sample code
-----------

**Closure**

    var locationManager = LocationManager.sharedInstance
            locationManager.showVerboseMessage = true
            locationManager.autoUpdate = false
            locationManager.startUpdatingLocation { (latitude, longitude, status, verboseMessage, error) -> () in
                
                println("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
                
                println(verboseMessage)
                
            }

----------

**Delegate**



    *class ViewController: UIViewController ,LocationManagerDelegate{....*
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var locationManager = LocationManager.sharedInstance
        locationManager.delegate = self
        }
    
     func locationManagerStatus(status:NSString){
        println(status)
        }
        
    func locationManagerReceivedError(error:NSString){
        println(error)
        }
        
        func locationFoundGetAsString(latitude: NSString, longitude: NSString) {
        println(latitude)
        println(longitude)
        }
        
        
        func locationFound(latitude:Double, longitude:Double){
            
        }

----------


Add Privacy - Location Usage Description  and NSLocationWhenInUseUsageDescription in your plist


Roadmap
---------------

 - Compatiblity check for iOS7 & iOS8  
 - iPhone4 and startMonitoringSignificantLocationChanges issue

----------
Contact Us
---------------

Have any questions or suggestions feel free to write at jimmy@varshyl.com (Jimmy Jose)
http://www.varshylmobile.com/

