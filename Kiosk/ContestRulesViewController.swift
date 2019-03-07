//
//  ContestRulesViewController.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 26/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import UIKit
import WebKit

class ContestRulesViewController: UIViewController {

    //IBOutlet
    @IBOutlet weak var webView: WKWebView!
    
    var contestUrl : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if contestUrl.absoluteString.contains("http") {
            webView.load(URLRequest(url: contestUrl))
        } else {
            let directoryUrl = contestUrl.absoluteString.replacingOccurrences(of: contestUrl.lastPathComponent, with: "")
            let folderUrl = URL(fileURLWithPath: directoryUrl, isDirectory: true)
            webView.loadFileURL(contestUrl, allowingReadAccessTo: folderUrl)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}

