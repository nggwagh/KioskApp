//
//  AppDelegate.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 15/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import UserNotifications
import IQKeyboardManagerSwift
import HockeySDK

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MagicalRecord.setupAutoMigratingCoreDataStack()
        MagicalRecord.setShouldDeleteStoreOnModelMismatch(true)

        BITHockeyManager.shared().configure(withIdentifier: "01a712893fe04dc7b9b952379367cdea")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        
        reloadRootViewController()
        
        for family in UIFont.familyNames {
            print("\(family)")
            for fontName in UIFont.fontNames(forFamilyName: family) {
                print("-> \(fontName)")
            }
        }
        
//        let font  = UIFont(name: "Bebas", size: 22)
        
        let _ = LocationService.shared
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        
        IQKeyboardManager.shared.enable = true
        
      //  SyncEngine.shared.startEngine()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AppDelegate.applicationDidTimeout(notification:)),
                                               name: .appIsIdle,
                                               object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
      //  SyncEngine.shared.startEngine()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        UserDefaults.standard.set(deviceTokenString, forKey: "Push_Token")
        
        print(deviceTokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        SyncEngine.shared.startEngine { (someNetworkCallSucceeded, errorOccured) in
            
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        SyncEngine.shared.startEngine { (someNetworkCallSucceeded, errorOccured) in
            
            if errorOccured {
                completionHandler(.failed)
            } else if someNetworkCallSucceeded {
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
            
        }
        
        
    }
    
    
    // MARK: - Other functions
    func reloadRootViewController() {
        self.window?.rootViewController = RootViewControllerFactory.getRootViewController()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Kiosk")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Timeout
    
    @objc func applicationDidTimeout(notification: NSNotification) {
        
        
        
    }

}






