//
//  LocationService.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 16/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationService: NSObject {
    
    static let shared = LocationService()
    
    let locationManger = CLLocationManager()
    
    let questionaireDistance = 5.0 //in km
    
    override init() {
        super.init()
        
        locationManger.requestWhenInUseAuthorization()
        
//        locationManger.desiredAccuracy = kCLLocationAccuracyKilometer
//
//        locationManger.distanceFilter = kCLDistanceFilterNone
//        
//        locationManger.allowsBackgroundLocationUpdates = true
//        
//        locationManger.pausesLocationUpdatesAutomatically = true
        
        locationManger.delegate = self
        
        locationManger.startMonitoringSignificantLocationChanges()

    }
    
    func checkAuthorization() -> Bool {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
        
    }
    
    func getCurrentCoordinates() -> (latitude:Double, longitude:Double)? {
        return (locationManger.location?.coordinate.latitude ?? 0, locationManger.location?.coordinate.longitude ?? 0)
    }
}



extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let moduleType = UserDefaults.standard.value(forKey: "moduleType") as? String {
            
            if (moduleType == "survey")
            {
                guard let locValue: CLLocationCoordinate2D = locations.last?.coordinate else { return }
                print("locations = \(locValue.latitude) \(locValue.longitude)")
                
                let launchTimeLat = LocationSettingManager.shared().getUserCurrentLatitude()
                let launchTimeLong = LocationSettingManager.shared().getUserCurrentLongitude()
                
                if (launchTimeLat == 0 && launchTimeLong == 0) {
                    LocationSettingManager.shared().setUserCurrentLatitude(locValue.latitude)
                    LocationSettingManager.shared().setUserCurrentLongitude(locValue.longitude)
                }
                else {
                    
                    let currentCoordinate = CLLocation(latitude: locValue.latitude, longitude:locValue.longitude)
                    
                    let distance = currentCoordinate.distanceFromCurrentLocationInKms(latitude: launchTimeLat!, longitude: launchTimeLong!)
                    
                    if (distance >= questionaireDistance) {
                        
                        //UPDATING LAT/LONG TO LATEST
                        LocationSettingManager.shared().setUserCurrentLatitude(locValue.latitude)
                        LocationSettingManager.shared().setUserCurrentLongitude(locValue.longitude)
                        
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.reloadRootViewController()
                        }
                    }
                }
                
            }
        }
    }
}

extension CLLocation {
    func distanceFromCurrentLocationInKms(latitude: Double, longitude: Double) -> Double{
        let coordinate = CLLocation(latitude: latitude, longitude: longitude)
        var distanceInMeters = self.distance(from: coordinate) // result is in meters
        distanceInMeters = distanceInMeters / 1000 //result in kilometers
        return distanceInMeters
    }
}
