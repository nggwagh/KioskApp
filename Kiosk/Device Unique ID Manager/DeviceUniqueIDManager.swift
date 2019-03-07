//
//  DeviceUniqueIDManager.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 15/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import Foundation
import SAMKeychain

class DeviceUniqueIDManager {
    
    static private let service = "KIOSK_SERVICE"
    static private let account = "KIOSK_ACCOUNT"
    
    static let shared  = DeviceUniqueIDManager()
    
    let uniqueID : String
    
    init() {
        if let uniqueIDFromKeyChain = SAMKeychain.password(forService: DeviceUniqueIDManager.service, account: DeviceUniqueIDManager.account){
            self.uniqueID = uniqueIDFromKeyChain
        } else {
            let newUniqueID = UUID().uuidString
            SAMKeychain.setPassword(newUniqueID, forService: DeviceUniqueIDManager.service, account: DeviceUniqueIDManager.account)
            self.uniqueID = newUniqueID;
        }
    }
    
    
    
}
