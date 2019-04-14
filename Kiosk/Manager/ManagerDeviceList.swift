//
//  ManagerDeviceList.swift
//  Kiosk
//
//  Created by Mohini Mehetre on 13/04/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//
import Foundation

struct Devices: Codable {
    let survey: Survey
    let group: Group
}

struct Group: Codable {
    let id: Int?
    let name: String
    let surveyID: Int?
    let devices: [DeviceElement]
}

struct DeviceElement: Codable {
    let id, surveyGroupID: Int?
    let deviceID: String
    let isManagerDevice: Int
    var lastEntries: [LastEntry]
    let device: DeviceDevice
}

struct DeviceDevice: Codable {
    let deviceID, name: String
}

struct LastEntry: Codable {
    let id: Int?
    let firstName: String
    let lastName: String
}

struct Survey: Codable {
    let id: Int?
    let name, createdAt, updatedAt: String
    let screensaverID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case screensaverID
    }
}


