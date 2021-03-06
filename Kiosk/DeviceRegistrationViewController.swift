//
//  ViewController.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 15/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import UIKit
import MagicalRecord

class DeviceRegistrationViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var txtDeviceName: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    var isFromSetting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnClose.isHidden = !isFromSetting
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - IBAction
    @IBAction func submitTapped(_ sender: UIButton) {
        
        if LocationService.shared.checkAuthorization() {
            if (txtDeviceName.text?.isEmpty)! {
                txtDeviceName.becomeFirstResponder()
            } else {
                let deviceInfo = DeviceInformation.mr_findFirst() ?? DeviceInformation.mr_createEntity()
                deviceInfo?.copy(deviceName: txtDeviceName.text!)
                NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
                
                sender.isEnabled = false
                
                KioskNetworkManager.shared.registerDevice { [weak self] success in
                    
                    if !success {
                        
                        if !(self?.isFromSetting)! {
                            sender.isEnabled = true
                            deviceInfo?.mr_deleteEntity()
                            NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
                        }
                        
                        let networkAlert = UIAlertController(title: "Milwaukee", message: "Network error. Please try again later.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        networkAlert.addAction(okAction)
                        self?.present(networkAlert, animated: true)
                        
                    } else if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                        
                        if !(self?.isFromSetting)! {
                            appDelegate.reloadRootViewController()
                        } else {
                            let networkAlert = UIAlertController(title: "Milwaukee", message: "Device name updated!", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                                self?.dismiss(animated: true)
                            }
                            networkAlert.addAction(okAction)
                            self?.present(networkAlert, animated: true)
                        }
                        SyncEngine.shared.startEngine()
                    }
                }
                
            }
        } else {
            
            let alertController = UIAlertController(title: "Enable Location Service", message: "Location Service is required for Device Registration.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                //Take to location setting
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    
}

