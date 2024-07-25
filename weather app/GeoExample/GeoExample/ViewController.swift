//
//  ViewController.swift
//  GeoExample
//
//  Created by Victoria Samsonova on 5.05.24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled on your device. In order to use this app, go to " +
                  "Settings → Privacy → Location Services and turn location services on.")
            return
        }
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                print("This app is not authorized to use your location. In order to use this app, " +
                      "go to Settings → GeoExample → Location and select the \"While Using " +
                      "the App\" setting.")
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func getCurrentLocationButtonPressed(_ sender: Any) {
    }
    
    // MARK: - CLLocationManagerDelegate methods
      
      // This is called if:
      // - the location manager is updating, and
      // - it was able to get the user's location.
      func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print(newLocation)
      }
      
      // This is called if:
      // - the location manager is updating, and
      // - it WASN'T able to get the user's location.
      func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error)")
      }

}
