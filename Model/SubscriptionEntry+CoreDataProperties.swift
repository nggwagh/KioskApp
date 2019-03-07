//
//  SubscriptionEntry+CoreDataProperties.swift
//  
//
//  Created by Mayur Deshmukh on 09/05/18.
//
//

import Foundation
import CoreData


extension SubscriptionEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubscriptionEntry> {
        return NSFetchRequest<SubscriptionEntry>(entityName: "SubscriptionEntry")
    }

    @NSManaged public var acceptsEmails: Bool
    @NSManaged public var acceptsNewsLetter: Bool
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var isSynced: Bool
    @NSManaged public var language: String?
    @NSManaged public var lastName: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var timeStamp: NSDate?
    @NSManaged public var trade: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var heardAbout: String?
    @NSManaged public var isReceiveDistributorEmails: Bool
}
