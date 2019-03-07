//
//  SyncEngine.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 25/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import Foundation
import MagicalRecord

extension Notification.Name {
    
    static let updatedScreenSaver = Notification.Name("didUpdateScreenSaver")
    
}

class SyncEngine {
    
    static let shared = SyncEngine()
     
    func startEngine (engineSuccess : ((Bool, Bool) -> Void)? = nil ) {
        
        guard DeviceInformation.mr_findFirst() != nil else { return }
        
        var someNetworkCallSucceeded = false
        var errorOccured = false
        var callCounter : Int = 0
        
        //Sync all local entries
        callCounter += 1
        syncEntries { success, error in
            someNetworkCallSucceeded = someNetworkCallSucceeded || success
            errorOccured = errorOccured || (error != nil)
            
            callCounter -= 1
            if callCounter == 0 {
                engineSuccess?(someNetworkCallSucceeded, errorOccured)
            }
        }
        
        //Sync changes in screensaver
        callCounter += 1
        syncDeviceGroupAndScreensaverInfo { success, error in
            someNetworkCallSucceeded = someNetworkCallSucceeded || success
            errorOccured = errorOccured || (error != nil)
            
            callCounter -= 1
            if callCounter == 0 {
                engineSuccess?(someNetworkCallSucceeded, errorOccured)
            }
            ScreenSaver.deleteInvalidScreenSaver()
            self.downloadScreensaver()
            self.downloadContestRules()
        }
        
    }
    
    private func downloadScreensaver() {
        let currentValidScreensaver = ScreenSaver.mr_findFirst(with: NSPredicate(format: "isValid == 1"))!
        
        guard currentValidScreensaver.localURL == nil else { return }
        
        KioskNetworkManager.shared.downloadScreensaver(for: currentValidScreensaver.serverId!, strUrl: currentValidScreensaver.remoteURL!) { (serverId, localUrl, error) in
            
            if error == nil {
                let screensaverForDownload = ScreenSaver.mr_findFirst(with: NSPredicate(format: "serverId == '\(serverId)'"))
                screensaverForDownload?.localURL = localUrl
                NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
            }
            
        }
    }
     
    private func downloadContestRules() {
        let currentValidScreensaver = ScreenSaver.mr_findFirst(with: NSPredicate(format: "isValid == 1"))!
        
        guard currentValidScreensaver.localContestRulesUrl == nil else { return }
        
        KioskNetworkManager.shared.downloadContestRules(for: currentValidScreensaver.serverId!, strUrl: currentValidScreensaver.remoteContestRulesUrl!) { (serverId, localUrl, error) in
            
            if error == nil {
                let screensaverForDownload = ScreenSaver.mr_findFirst(with: NSPredicate(format: "serverId == '\(serverId)'"))
                screensaverForDownload?.localContestRulesUrl = localUrl
                NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
            }
            
        }
    }
    
    
    private func syncEntries( completion : @escaping (Bool, Error?) -> Void) {
        
        let arrayOfUnsyncedEntries = SubscriptionEntry.getArrayOfAllUnsyncedEntries()
        
        var unsynedDictionary = SubscriptionEntry.toArray(entries: arrayOfUnsyncedEntries)
        
        KioskNetworkManager.shared.postEntries(unsynedDictionary) { success, error in
            if success {
                SubscriptionEntry.markAsSynced(entries: arrayOfUnsyncedEntries)
                NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
            }
            completion(success, error)
        }
    }
    
    private func syncDeviceGroupAndScreensaverInfo ( completion : @escaping (Bool, Error?) -> Void) {
        
        KioskNetworkManager
            .shared
            .getScreenSaverInfo(forDeviceId: DeviceUniqueIDManager
                                                .shared
                                                .uniqueID) { (dictOfDeviceInfo, error) in
            
                                                    if let syncError = error {
                                                        completion(false, syncError)
                                                    } else {
                                                        
                                                        if let localScreensavers = ScreenSaver.mr_findAll() as? [ScreenSaver]{
                                                            for localScreenSaver in localScreensavers {
                                                                localScreenSaver.invalidate()
                                                            }
                                                        }
                                                        
                                                        let groupInfo = dictOfDeviceInfo!["group"] as! [String : Any]
                                                        let screensaverInfo = groupInfo["screensaver"] as! [String : Any]
                                                        let screensaverId = screensaverInfo["id"] as! NSNumber
                                                        let strScreenSaverId = String(screensaverId.intValue)
                                                        
                                                        let existingScreensaver = ScreenSaver.mr_findFirst(with: NSPredicate(format: "serverId == '\(strScreenSaverId)'"))
                                                        
                                                        var isNewScreenSaver = false
                                                        
                                                        var newScreensaver : ScreenSaver
                                                        if existingScreensaver != nil {
                                                            newScreensaver = existingScreensaver!
                                                        } else {
                                                            newScreensaver = ScreenSaver.mr_createEntity()!
                                                            isNewScreenSaver = true
                                                        }
                                                        
                                                        let remoteScreenSaverUrl = screensaverInfo["url"] as! String
                                                        let isContest = screensaverInfo["isContest"] as! Bool
                                                        let remoteContestUrl = screensaverInfo["contestRulesURL"] as! String
                                                        let enableDistributorOptin = screensaverInfo["enableDistributorOptin"] as! Bool
                                                        let contactNameString = dictOfDeviceInfo!["contactName"] as? String
                                                        let contactEmailString = dictOfDeviceInfo!["contactEmail"] as? String
                                                        let contactPhoneString = dictOfDeviceInfo!["contactPhone"] as? String

                                                        //contactName
                                                        //contactEmail
                                                        //contactPhone
                                                        
                                                            newScreensaver.copy(withId: strScreenSaverId, url: remoteScreenSaverUrl, isContestScreenSaver: isContest, contestUrl: remoteContestUrl, shouldShowDistributorOptin: enableDistributorOptin,contactName: contactNameString, contactPhone: contactPhoneString, contactEmail: contactEmailString)
                                                        
                                                        NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
                                                        
                                                        completion(true, nil)
                                                        
                                                        if isNewScreenSaver {
                                                            NotificationCenter.default.post(name: .updatedScreenSaver, object: nil)
                                                        }
                                                    }
        }
        

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


