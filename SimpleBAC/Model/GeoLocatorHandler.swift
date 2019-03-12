//
//  GeoLocator.swift
//  LastDrop
//
//  Created by Mark Wong on 8/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import Foundation
import CoreLocation

@objc protocol GeoLocatorProtocol {
    @objc optional func updateCountry(country: String)
}

class GeoLocatorHandler: NSObject, CLLocationManagerDelegate {
    static let shared: GeoLocatorHandler = GeoLocatorHandler()
    var locManager: CLLocationManager = CLLocationManager()
    var status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    var currentLocation: CLLocation!
    var long: Double?
    var lat: Double?
    var mainViewControllerDelegate: GeoLocatorProtocol?
    var country: String = "" {
        didSet {
//            print("didSet Country - \(country)")
            self.mainViewControllerDelegate?.updateCountry?(country: self.country)
        }
    }
    
    override init() {
        super.init()
        locManager.delegate = self
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.setupAndBeginAuthorization()
            self.retrieveLocationLongLat()
            self.retrieveReadableLocation()
            break
        case .authorizedAlways:
            self.setupAndBeginAuthorizationAlways()
            self.retrieveLocationLongLat()
            self.retrieveReadableLocation()
            break
        case .notDetermined:
            locManager.requestWhenInUseAuthorization()
        case .denied:
            //set unknown location with 0.05 limit and 10 gram alcohol mass
            self.isLocationDisableForMyAppOnly()
//            print("I'm sorry - I can't show location. User has not authorized it")
        //statusDeniedAlert()
        case .restricted:
            self.isLocationDisableForMyAppOnly()

//            print("Access to location services is restricted")
            //            showAlert(title: "Access to Location Services is Restricted", message: "Parental Controls or a system administrator may be limiting your access to location services. Ask them to.")
        }
    }
    
    func isLocationDisableForMyAppOnly() -> Void {
        self.country = "Unknown"
    }
    
    func setupAndBeginAuthorizationAlways() -> Void {
        locManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locManager.requestWhenInUseAuthorization()
        locManager.allowsBackgroundLocationUpdates = true
        locManager.activityType = .fitness //more like exercising drinks
        self.start()
    }
    
    func setupAndBeginAuthorization() -> Void {
        locManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locManager.requestWhenInUseAuthorization() 
        locManager.activityType = .fitness //more like exercising drinks
        self.start()
    }
    
    func start() {
        locManager.startUpdatingLocation()
    }
    
    func stop() {
        locManager.stopUpdatingLocation()
    }
    
    func retrieveReadableLocation() -> Void {
        guard let currLocation = self.currentLocation else {
            return
        }
        CLGeocoder().reverseGeocodeLocation(currLocation, completionHandler: {(placemarks, error) -> Void in

            if error != nil {
//                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }

            if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                guard let c = pm.country else {
                    assertionFailure("Failed to get country")
                    return
                }
//                print("Country - \(self.country)")
                self.country = c
            }
            else {
//                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func getCountry() -> String {
        return self.country
    }
    
    func retrieveLocationLongLat() -> Void {
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            self.currentLocation = locManager.location
            
            if (locManager.location == nil) {
                self.country = "Unknown"
            }
        }
        else {
            if (locManager.location == nil) {
                self.country = "Unknown"
            }
        }
//        print("my lat:\(locManager.location?.coordinate.latitude ?? 0.0)")
//        print("my long:\(locManager.location?.coordinate.longitude ?? 0.0)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ 
        nager: CLLocationManager, didFailWithError error: Error) {
        self.stop()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
        guard let lastLocation = locations.last else {
            return
        }
        currentLocation = lastLocation
    }
    
    func forceLocationRetrieval() {
        locManager.requestAlwaysAuthorization()
        self.retrieveLocationLongLat()
        self.retrieveReadableLocation()
    }

}
