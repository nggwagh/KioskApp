//
//  LocationService.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 16/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import Foundation
import CoreLocation


class LocationService {
    
    static let shared = LocationService()
    
    let locationManger = CLLocationManager()
    
    init() {
        locationManger.requestWhenInUseAuthorization()
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
