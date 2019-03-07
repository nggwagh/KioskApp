//
//  ScreenSaver+CoreDataClass.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 10/05/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//
//

import Foundation
import CoreData
import Alamofire

@objc(ScreenSaver)
public class ScreenSaver: NSManagedObject {
    func copy(withId id : String, url : String, isContestScreenSaver : Bool, contestUrl : String, shouldShowDistributorOptin: Bool, contactName: String?, contactPhone: String?, contactEmail: String?) {
        
        self.isValid = true
        self.isCurrent = true
        
        self.serverId = id
        self.remoteURL = url
        //        self.remoteURL = "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        
        self.isContest = isContestScreenSaver
        self.remoteContestRulesUrl = contestUrl
        self.enableDistributorOptin = shouldShowDistributorOptin
        self.contactName = contactName
        self.contactPhone = contactPhone
        self.contactEmail = contactEmail
    }
    
    func invalidate() {
        self.isValid = false
        self.isCurrent = false
    }
    
    static func getUrlForScreensaver () -> URL? {
        
        let currentValidScreensaver = ScreenSaver.mr_findFirst(with: NSPredicate(format: "isValid == 1"))
        
        if let localUrl = currentValidScreensaver?.localURL {
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent(localUrl) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    return URL(fileURLWithPath: filePath)
                } else {
                    print("FILE NOT AVAILABLE")
                }
            } else {
                print("FILE PATH NOT AVAILABLE")
            }
            
            
            
        } else if let remoteUrl = currentValidScreensaver?.remoteURL {
            if NetworkReachabilityManager()?.isReachable == true {
                return URL(string: remoteUrl)
            }
        }
        
        return nil
        
    }
    
    static func getUrlForContestRules () -> URL? {
        
        let currentValidScreensaver = ScreenSaver.mr_findFirst(with: NSPredicate(format: "isValid == 1"))
        
        if let localUrl = currentValidScreensaver?.localContestRulesUrl {
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent(localUrl) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    return URL(fileURLWithPath: filePath)
                } else {
                    print("FILE NOT AVAILABLE")
                }
            } else {
                print("FILE PATH NOT AVAILABLE")
            }
            
            
            
        } else if let remoteUrl = currentValidScreensaver?.remoteContestRulesUrl {
            if NetworkReachabilityManager()?.isReachable == true {
                return URL(string: remoteUrl)
            }
        }
        
        return nil
        
    }
    
    static func isCurrentScreenSaverAContest() -> Bool {
        
        if let currentValidScreensaver = ScreenSaver.mr_findFirst(with: NSPredicate(format: "isValid == 1")) {
            return currentValidScreensaver.isContest
        }
        return false
        
    }
    
    
    
    static func deleteInvalidScreenSaver() {
        
        if let invalidScreenSavers = ScreenSaver.mr_findAll(with: NSPredicate(format: "isValid == 0")){
            for screensaver in invalidScreenSavers {
                screensaver.mr_deleteEntity()
            }
            NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
        }
        
        
    }
    
    static func shouldShownDistributorCheckBox() -> Bool {
        
        if let currentValidScreensaver = ScreenSaver.mr_findFirst(with: NSPredicate(format: "isValid == 1")) {
            return currentValidScreensaver.enableDistributorOptin
        }
        return false
        
    }

    
    static func shouldShownContactWinner() -> String? {
        
        if let currentValidScreensaver = ScreenSaver.mr_findFirst(with: NSPredicate(format: "isValid == 1")) {
            return currentValidScreensaver.contactName
        }
        return nil
        
    }
    
    
    
    
    
    
}
