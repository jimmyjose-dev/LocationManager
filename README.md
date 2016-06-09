LocationManager
=====================

Location manager is a CLLocationManager wrapper written entirely in Swift
----------------------------------

**Updated for XCode 7.0 and iOS 9.0.1**

**Features:**
>  1) Location update with closure & delegate support 
>  
>  2) Geocoding and reverse geocoding using Apple service 
>  
>  3) Geocoding and reverse geocoding using Google service
>
> 4) Closure returns CLPlacemark object, making it easier to place pin on map


----------


**Try this too:**
https://github.com/varshylmobile/MapManager


----------

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries.
You can install it with the following command:

```bash
$ gem install cocoapods
```
#### Podfile

To integrate VMLocationManager into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'VMLocationManager', '~> 1.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```

Screenshot
==========

![Screenshot](https://s3.amazonaws.com/cocoacontrols_production/uploads/control_image/image/4589/iOS_Simulator_Screen_Shot_28-Aug-2014_4.00.24_pm.png)



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

Contributors 
---------------
***All contributors will receive virtual high fives from me and for the heck of it lets forget you are a south paw***

![enter image description here](https://dl.dropbox.com/s/n32dq4fle8fh7l4/internet-high-five.jpg)


----------
Other Repos you might like
--------------------------

1) https://github.com/varshylmobile/MapManager

> Map manager is a MapKit wrapper in Swift to provide route direction
> drawing

2) https://github.com/varshylmobile/VMXMLParser

> NSXMLParser wrapper in Swift

3) https://github.com/varshylmobile/RateMyApp

> RateMyApp is a Swift class to provide gentle reminders to app user to
> rate your app

4) https://github.com/varshylmobile/TableViewCellFlip

> Vertical and Horizontal flip animation for table view cell

Contact Us
---------------

Have any questions or suggestions feel free to write at jimmy@varshyl.com (Jimmy Jose)
http://www.varshylmobile.com/

----------
## License

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/varshylmobile/locationmanager/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

