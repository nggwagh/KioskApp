//
//  DeviceInformation+CoreDataClass.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 15/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DeviceInformation)
public class DeviceInformation: NSManagedObject {

    
    func copy(deviceName : String) {
        self.name = deviceName
    }
    
    func getDictionary() -> [String : Any] {
        return ["name" : name!]
    }
    
}
