//
//  main.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 29/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import Foundation
import UIKit

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(KioskTimedApplication.self),
    NSStringFromClass(AppDelegate.self)
)



