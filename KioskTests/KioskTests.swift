//
//  KioskTests.swift
//  KioskTests
//
//  Created by Mayur Deshmukh on 15/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import XCTest
@testable import Kiosk
import MagicalRecord

class KioskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeviceUniqueIDManager() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertNotNil(DeviceUniqueIDManager.shared.uniqueID)
    }
    
    func testDeviceInformationPersistence(){
        
        let deviceInfo = DeviceInformation.mr_createEntity()
        XCTAssertNotNil(deviceInfo)
        deviceInfo?.copy(deviceName: "SomeRandomName")
        NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
        NSManagedObjectContext.mr_contextForCurrentThread().reset()
        
        let fetchedDeviceInfo = DeviceInformation.mr_findFirst()!
        XCTAssertNotNil(fetchedDeviceInfo)
        let dictOfDeviceInfo = fetchedDeviceInfo.getDictionary()
        
        XCTAssertEqual(dictOfDeviceInfo["name"] as! String, "SomeRandomName")
        
        fetchedDeviceInfo.mr_deleteEntity()
        NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
        
        XCTAssertEqual(DeviceInformation.mr_countOfEntities(), 0)
    }
    
    func testRootViewControllerFactory() {
        
        let registrationController = RootViewControllerFactory.getRootViewController()
        XCTAssertNotNil(registrationController)
        XCTAssertTrue(registrationController is DeviceRegistrationViewController, "Controller should be DeviceRegistrationViewController!! It is not!")

        let deviceInfo = DeviceInformation.mr_createEntity()
        XCTAssertNotNil(deviceInfo)
        deviceInfo?.copy(deviceName: "SomeRandomName")
        NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
        NSManagedObjectContext.mr_contextForCurrentThread().reset()

        let subscriptionController = RootViewControllerFactory.getRootViewController()
        XCTAssertNotNil(subscriptionController)
        XCTAssertTrue(subscriptionController is SubscriptionFormViewController)

        let fetchedDeviceInfo = DeviceInformation.mr_findFirst()!
        XCTAssertNotNil(fetchedDeviceInfo)
        fetchedDeviceInfo.mr_deleteEntity()
        NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
        XCTAssertEqual(DeviceInformation.mr_countOfEntities(), 0)

        
    }
    
}
