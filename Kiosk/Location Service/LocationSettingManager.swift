//
//  LocationSettingManager.swift
//  Kiosk
//
//  Created by Mohini Mehetre on 01/04/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import UIKit

class LocationSettingManager: NSObject {

    private static var sharedInstance: LocationSettingManager  =  {
        let locationSettingManager = LocationSettingManager()
        return locationSettingManager
    }()
    
    // This prevents others from using the default '()' initializer for this class.
    override private init() {
        super.init()
    }
    
    // MARK:- Accessor - Shared instance
    class func shared() -> LocationSettingManager {
        return sharedInstance
    }
    
    // MARK:- User location Latitude -
    func setUserCurrentLatitude(_ latitude: Double) {
        UserDefaults.standard.set(latitude, forKey: Constant.LocationKeys.currentLatitude)
        UserDefaults.standard.synchronize()
    }
    func getUserCurrentLatitude() -> Double? {
        let latitude = UserDefaults.standard.double(forKey: Constant.LocationKeys.currentLatitude)
        return (latitude)
    }
    
    // MARK:- User location Longitude -
    func setUserCurrentLongitude(_ longitude: Double) {
        UserDefaults.standard.set(longitude, forKey: Constant.LocationKeys.currentLongitude)
        UserDefaults.standard.synchronize()
    }
    func getUserCurrentLongitude() -> Double? {
        let latitude = UserDefaults.standard.double(forKey: Constant.LocationKeys.currentLongitude)
        return (latitude)
    }
    
}
