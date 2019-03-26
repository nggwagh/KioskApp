//
//  ThanksViewController.swift
//  Kiosk
//
//  Created by Nikhil Wagh on 3/17/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(navigateToEnterNowScreen), userInfo: nil, repeats: false)
    }
    
    // MARK: - Private Methods
    
    @objc func navigateToEnterNowScreen() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
