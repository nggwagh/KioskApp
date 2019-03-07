//
//  ScreenSaver+CoreDataProperties.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 10/05/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//
//

import Foundation
import CoreData


extension ScreenSaver {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScreenSaver> {
        return NSFetchRequest<ScreenSaver>(entityName: "ScreenSaver")
    }

    @NSManaged public var isCurrent: Bool
    @NSManaged public var isValid: Bool
    @NSManaged public var localURL: String?
    @NSManaged public var remoteURL: String?
    @NSManaged public var serverId: String?
    @NSManaged public var isContest: Bool
    @NSManaged public var remoteContestRulesUrl: String?
    @NSManaged public var localContestRulesUrl: String?
    @NSManaged public var enableDistributorOptin: Bool
    @NSManaged public var contactEmail: String?
    @NSManaged public var contactName: String?
    @NSManaged public var contactPhone: String?

}
