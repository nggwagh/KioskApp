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
    
    override func viewWillAppear(_ animated: Bool) {

        //reset language preference to english again
        UserDefaults.standard.set("EN", forKey: Constant.UserDefaultKey.languagePreference)
        UserDefaults.standard.synchronize()
        self.initializeView()
    }
    
    // MARK: - Private Methods
    func initializeView() {
        let languagePreference = UserDefaults.standard.value(forKey: Constant.UserDefaultKey.languagePreference) as! String
        if (languagePreference == "FR") {
            
            let frenchString: String = "COMMENCEZ DÉS MAINTENANT POUR OBTENIR VOTRE PRODUIT MILWAUKEE GRATUIT"
            let attributeText_french = NSMutableAttributedString.init(string: frenchString)
             attributeText_french.addAttribute(.font, value: UIFont(name: "Helvetica-Bold", size: 85.0)!, range: NSMakeRange(0, attributeText_french.length))
            
            frenchString.enumerateSubstrings(in: frenchString.startIndex..<frenchString.endIndex, options: .byWords) {
                (substring, substringRange, _, _) in
                if substring == "GRATUIT" {
                    attributeText_french.addAttribute(.foregroundColor, value: UIColor.black,
                                                      range: NSRange(substringRange, in: frenchString))
                    
                    attributeText_french.addAttribute(.font, value: UIFont(name: "Helvetica-Bold", size: 110.0)!,
                                                      range: NSRange(substringRange, in: frenchString))
                }
            }
            infoLabel.attributedText = attributeText_french
            
            enterNowButton.setTitle("   ENTRE MAINTENANT   ", for: UIControlState.normal)
        }
        else {
            
            let englishString: String = "START NOW TO GET YOUR FREE \n MILWAUKEE PRODUCT"
            let attributeText_english = NSMutableAttributedString.init(string: englishString)
            attributeText_english.addAttribute(.font, value: UIFont(name: "Helvetica-Bold", size: 85.0)!, range: NSMakeRange(0, attributeText_english.length))
            
            englishString.enumerateSubstrings(in: englishString.startIndex..<englishString.endIndex, options: .byWords) {
                (substring, substringRange, _, _) in
                if substring == "FREE" {
                    attributeText_english.addAttribute(.foregroundColor, value: UIColor.black,
                                                      range: NSRange(substringRange, in: englishString))
                    
                    attributeText_english.addAttribute(.font, value: UIFont(name: "Helvetica-Bold", size: 110.0)!,
                                                      range: NSRange(substringRange, in: englishString))
                }
            }
            infoLabel.attributedText = attributeText_english
            
            enterNowButton.setTitle("ENTER NOW", for: UIControlState.normal)
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
