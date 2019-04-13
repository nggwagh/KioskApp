//
//  ManagerViewController.swift
//  Kiosk
//
//  Created by Mohini Mehetre on 30/03/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import UIKit
import SafariServices

class ManagerViewController: UIViewController {
    
    var iPad1VC : ManagerContainerController?
    var iPad2VC : ManagerContainerController?
    var iPad3VC : ManagerContainerController?
    var iPad4VC : ManagerContainerController?
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    var devices = [DeviceElement]()
    var numberOfLogoTaps = 0
    var isloaded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if isloaded {
            appDel.myOrientation = .landscape
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isloaded {
            appDel.myOrientation = .landscape
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        } else {
            isloaded = false
        }
        
        self.getDeviceWinnerList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDel.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    // MARK: - Navigation
    
    func getDeviceWinnerList() {
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        let id = UserDefaults.standard.value(forKey: "moduleTypeID")
        
        KioskNetworkManager.shared.getDevicewiseWinners(id: id as! Int) { (responseJson) in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            do {
                // Convert object to JSON as NSData
                let jsonData = try JSONSerialization.data(withJSONObject: responseJson!, options: [])
                let decoder = JSONDecoder()
                let deviceDetails = try decoder.decode(Devices.self, from: jsonData) as Devices
                self.devices = deviceDetails.group.devices.filter { $0.isManagerDevice == 0 }
                self.reloadDevices()
                print("success")
            } catch {
                print("error writing JSON: \(error)")
            }
        }
    }
    
    func reloadDevicesFromPushNotification(id: Int, entry: String, deviceID: String) {
        if (iPad1VC != nil) {
            if (self.devices.count >= 1) {
                if (self.devices[0].deviceID == deviceID) {
                    let latestEntry = LastEntry.init(id: id, firstName: entry, lastName: "")
                    self.devices[0].lastEntries.insert(latestEntry, at: 0)
                    iPad1VC?.usersArray = self.devices[0].lastEntries
                    iPad1VC?.deviceName = self.devices[0].device.name
                    iPad1VC?.reloadDeviceEntries()
                }
            }
        }
        
        if (iPad2VC != nil) {
            if (self.devices.count >= 2) {
                if (self.devices[1].deviceID == deviceID) {
                    let latestEntry = LastEntry.init(id: id, firstName: entry, lastName: "")
                    self.devices[1].lastEntries.insert(latestEntry, at: 0)
                    iPad2VC?.usersArray = self.devices[1].lastEntries
                    iPad2VC?.deviceName = self.devices[1].device.name
                    iPad2VC?.reloadDeviceEntries()
                }
            }
        }
        
        if (iPad3VC != nil) {
            if (self.devices.count >= 3) {
                if (self.devices[2].deviceID == deviceID) {
                    let latestEntry = LastEntry.init(id: id, firstName: entry, lastName: "")
                    self.devices[2].lastEntries.insert(latestEntry, at: 0)
                    iPad3VC?.usersArray = self.devices[2].lastEntries
                    iPad3VC?.deviceName = self.devices[2].device.name
                    iPad3VC?.reloadDeviceEntries()
                }
            }
        }
        
        if (iPad4VC != nil) {
            if (self.devices.count >= 4) {
                if (self.devices[3].deviceID == deviceID) {
                    let latestEntry = LastEntry.init(id: id, firstName: entry, lastName: "")
                    self.devices[3].lastEntries.insert(latestEntry, at: 0)
                    iPad4VC?.usersArray = self.devices[3].lastEntries
                    iPad4VC?.deviceName = self.devices[3].device.name
                    iPad4VC?.reloadDeviceEntries()
                }
            }
            
        }
    }
    
    func reloadDevices() {
        if (iPad1VC != nil) {
            if (self.devices.count >= 1) {
                iPad1VC?.usersArray = self.devices[0].lastEntries
                iPad1VC?.deviceName = self.devices[0].device.name
            }
            iPad1VC?.reloadDeviceEntries()
        }
        
        if (iPad2VC != nil) {
            if (self.devices.count >= 2) {
                iPad2VC?.usersArray = self.devices[1].lastEntries
                iPad2VC?.deviceName = self.devices[1].device.name
            }
            iPad2VC?.reloadDeviceEntries()
        }
        
        if (iPad3VC != nil) {
            if (self.devices.count >= 3) {
                iPad3VC?.usersArray = self.devices[2].lastEntries
                iPad3VC?.deviceName = self.devices[2].device.name
            }
            iPad3VC?.reloadDeviceEntries()
        }
        
        if (iPad4VC != nil) {
            if (self.devices.count >= 4) {
                iPad4VC?.usersArray = self.devices[3].lastEntries
                iPad4VC?.deviceName = self.devices[3].device.name
            }
            iPad4VC?.reloadDeviceEntries()
        }
    }

    // MARK: - IBAction Methods

    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.getDeviceWinnerList()
    }
    
    @IBAction func logoTapped(_ sender: Any) {
        
        numberOfLogoTaps += 1
        
        if numberOfLogoTaps == 5 {
            
            numberOfLogoTaps = 0
            
            let masterPasswordAlertController = UIAlertController(title: "Milwaukee", message: "Please enter master key.", preferredStyle: .alert)
            
            masterPasswordAlertController.addTextField { (textField) in
                textField.placeholder = "Master key"
                textField.isSecureTextEntry = true
                textField.borderStyle = .roundedRect
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { submitAction in
                let passwordField = masterPasswordAlertController.textFields![0]
                
                if passwordField.text == "tticanada" {
                    self.showOptions()
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { cancelAction in
                
            }
            
            masterPasswordAlertController.addAction(submitAction)
            masterPasswordAlertController.addAction(cancelAction)
            
            self.present(masterPasswordAlertController, animated: true)
        }
    }
    
    func showOptions() {
        let masterPasswordAlertController = UIAlertController(title: "Milwaukee", message: "Please select one option.", preferredStyle: .alert)
        
        let dashboardAction = UIAlertAction(title: "DashBoard", style: .default) { submitAction in
            
            let serverUrlString =  KioskNetworkManager.serverUrl
            let completeURLString = serverUrlString + "#" + "/device/" + DeviceUniqueIDManager.shared.uniqueID + "/stats"
            
            let dashboardViewController = SFSafariViewController(url: URL(string: completeURLString)!)
            dashboardViewController.navigationItem.setRightBarButtonItems([], animated: true)
            self.present(dashboardViewController, animated: true){
                let width: CGFloat = 130
                let x: CGFloat = self.view.frame.width - width
                
                // It can be any overlay. May be your logo image here inside an imageView.
                let overlay = UIView(frame: CGRect(x: x, y: 20, width: width, height: 44))
                overlay.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                dashboardViewController.view.addSubview(overlay)
            }
        }
        
        let deviceNameAction = UIAlertAction(title: "Change Device Name", style: .default) { submitAction in
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.loadDeviceNameScreen()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { cancelAction in
            
        }
        
        masterPasswordAlertController.addAction(dashboardAction)
        masterPasswordAlertController.addAction(deviceNameAction)
        masterPasswordAlertController.addAction(cancelAction)
        
        self.present(masterPasswordAlertController, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "iPadOneIdentifier" {
            iPad1VC = segue.destination as? ManagerContainerController
        }
        if segue.identifier == "iPadTwoIdentifier" {
            iPad2VC = segue.destination as? ManagerContainerController
        }
        if segue.identifier == "iPadThreeIdentifier" {
            iPad3VC = segue.destination as? ManagerContainerController
        }
        if segue.identifier == "iPadFourIdentifier" {
            iPad4VC = segue.destination as? ManagerContainerController
        }
    }
}
