//
//  DeviceInformation+CoreDataProperties.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 15/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//
//

import Foundation
import CoreData


extension DeviceInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeviceInformation> {
        return NSFetchRequest<DeviceInformation>(entityName: "DeviceInformation")
    }

    @NSManaged public var uniqueID: String?
    @NSManaged public var groupID: String?
    @NSManaged public var name: String?

}
