//
//  SubscriptionEntry+CoreDataClass.swift
//  
//
//  Created by Mayur Deshmukh on 25/04/18.
//
//

import Foundation
import CoreData

@objc(SubscriptionEntry)
public class SubscriptionEntry: NSManagedObject {
    
    func copy (withFirstname strFirstName: String,
               lastName strLastName : String,
               email strEmail : String,
               postalCode strPostalCode : String,
               trade usersTrade : String,
               hearAbout selectedhearAbout : String,
               language languagePreferred : LanguagePreference,
               acceptsNewsLetter userAcceptedNewLetter : Bool,
               acceptsEmails userAcceptedEmails : Bool,
               coordinates : (latitude : Double, longitude : Double),
               isReceiveDistributorEmails: Bool) {
        
        self.firstName = strFirstName
        self.lastName = strLastName
        self.email = strEmail
        self.postalCode = strPostalCode
        self.trade = usersTrade
        self.language = languagePreferred.localeCode
        self.acceptsNewsLetter = userAcceptedNewLetter
        self.acceptsEmails = userAcceptedEmails
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
        self.heardAbout = selectedhearAbout
        self.timeStamp = NSDate()
        self.isReceiveDistributorEmails = isReceiveDistributorEmails
        self.isSynced = false
    }
    
    func toDictionary() -> [String : Any] {
        
        var entryDict = [String : Any]()
        
        entryDict["firstName"] = self.firstName
        entryDict["lastName"] = self.lastName
        entryDict["email"] = self.email
//        entryDict["postalCode"] = self.postalCode
        entryDict["trade"] = self.trade
        entryDict["language"] = self.language
        entryDict["acceptsNewsletter"] = self.acceptsNewsLetter
        entryDict["receiveEmails"] = self.acceptsEmails
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        entryDict["timeStamp"] = dateFormatter.string(from: self.timeStamp! as Date)
        entryDict["deviceID"] = DeviceUniqueIDManager.shared.uniqueID
        
        entryDict["latitude"] = self.latitude
        entryDict["longitude"] = self.longitude
        entryDict["heardAbout"] = self.heardAbout
        entryDict["receiveDistributorEmails"] = self.isReceiveDistributorEmails

        return entryDict
    }
    
    static func getArrayOfAllUnsyncedEntries() -> [SubscriptionEntry] {
        return SubscriptionEntry.mr_findAll(with: NSPredicate(format: "isSynced == 0")) as! [SubscriptionEntry]
    }
    
    static func toArray (entries : [SubscriptionEntry]) -> [[String : Any]] {
        
        var arrayOfUnsyncedEntryDicts = [[String : Any]]()
        for subscriptionEntry in entries {
            arrayOfUnsyncedEntryDicts.append(subscriptionEntry.toDictionary())
        }
        return arrayOfUnsyncedEntryDicts
        
    }
    
    static func markAsSynced(entries : [SubscriptionEntry]) {
    
        for subscriptionEntry in entries {
            subscriptionEntry.isSynced = true
        }
        
    }
    
}
