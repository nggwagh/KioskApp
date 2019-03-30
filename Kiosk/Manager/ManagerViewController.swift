//
//  ManagerViewController.swift
//  Kiosk
//
//  Created by Mohini Mehetre on 30/03/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import UIKit

class ManagerViewController: UIViewController {

    var iPad1VC = ManagerContainerController()
    var iPad2VC = ManagerContainerController()
    var iPad3VC = ManagerContainerController()
    var iPad4VC = ManagerContainerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

   }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "iPadOneIdentifier" {
            iPad1VC = segue.destination as! ManagerContainerController
            iPad1VC.usersArray = ["Device 1"]
        }
        if segue.identifier == "iPadTwoIdentifier" {
            iPad2VC = segue.destination as! ManagerContainerController
            iPad2VC.usersArray = ["Device 2"]
        }
        if segue.identifier == "iPadThreeIdentifier" {
            iPad3VC = segue.destination as! ManagerContainerController
            iPad3VC.usersArray = ["Device dddsdsdsdsdsd ds3"]
        }
        if segue.identifier == "iPadFourIdentifier" {
            iPad4VC = segue.destination as! ManagerContainerController
            iPad4VC.usersArray = ["Device 4"]
        }
    }
}
