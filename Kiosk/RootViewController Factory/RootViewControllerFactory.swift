//
//  RootViewControllerFactory.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 15/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import Foundation
import UIKit

class RootViewControllerFactory {
    
    static func getRootViewController() -> UIViewController {
        
        if DeviceInformation.mr_countOfEntities() == 0 {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceRegistrationViewController")
        } else {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionFormViewController")
        }
    }
    
}
