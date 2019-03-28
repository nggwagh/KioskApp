//
//  EnterNowViewController.swift
//  Kiosk
//
//  Created by Nikhil Wagh on 3/17/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import UIKit

class EnterNowViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var enterNowButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initializeView()
    }
    
    // MARK: - Private Methods
    func initializeView() {
        let isFrenchSelected = true
        if (isFrenchSelected) {
            
            let frenchString: String = "COMMENCEZ DÉS MAINTENANT POUR OBTENIR VOTRE PRODUIT MILWAUKEE GRATUIT"
            let attributeText_french = NSMutableAttributedString.init(string: frenchString)
            
            frenchString.enumerateSubstrings(in: frenchString.startIndex..<frenchString.endIndex, options: .byWords) {
                (substring, substringRange, _, _) in
                if substring == "GRATUIT" {
                    attributeText_french.addAttribute(.foregroundColor, value: UIColor.black,
                                                      range: NSRange(substringRange, in: frenchString))
                    
                    attributeText_french.addAttribute(.font, value: UIFont(name: self.infoLabel.font.fontName, size: 110.0)!,
                                                      range: NSRange(substringRange, in: frenchString))
                }
            }
            infoLabel.attributedText = attributeText_french
            
            enterNowButton.setTitle("   ENTRE MAINTENANT   ", for: UIControlState.normal)
        }
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
