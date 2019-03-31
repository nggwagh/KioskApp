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
            if let moduleType = UserDefaults.standard.value(forKey: "moduleType") as? String {
                
                if (moduleType == "survey")
                {
                    return UIStoryboard(name: "Questionnaire", bundle: nil).instantiateInitialViewController()!
                }
                else if (moduleType == "survey_admin")
                {
                    return UIStoryboard(name: "Manager", bundle: nil).instantiateInitialViewController()!
                }
                else if ((moduleType == "signup") || (moduleType == "contest"))
                {
                    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionFormViewController")
                }
            }
            return UIStoryboard(name: "Questionnaire", bundle: nil).instantiateInitialViewController()!
        }
    }
    
}
