//
//  ThanksViewController.swift
//  Kiosk
//
//  Created by Nikhil Wagh on 3/17/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var finishedButton: UIButton!
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(navigateToEnterNowScreen), userInfo: nil, repeats: false)
        
        self.initializeView()
    }
    
    // MARK: - Private Methods
    func initializeView() {
        let languagePreference = UserDefaults.standard.value(forKey: Constant.UserDefaultKey.languagePreference) as! String
       if (languagePreference == "FR") {
//            let frenchString: String = "MERCI \n SIIL VOUS PLATT VOIR LE REPRÉSENTANT DE MILWAUKEE POUR RÉCLAMER VOTRE BON"
            let frenchString: String = "JE VOUS REMERCIE \n VEUILLEZ CONSULTER LE REPRÉSENTANT DE MILWAUKEE POUR RÉCLAMER VOTRE BIEN GRATUIT"

            let attributeText_french = NSMutableAttributedString.init(string: frenchString)
            attributeText_french.addAttribute(.foregroundColor, value: UIColor.red,
                                              range: NSMakeRange(0, attributeText_french.length))
            attributeText_french.addAttribute(.font, value: UIFont(name: "Helvetica-Bold", size: 85.0)!, range: NSMakeRange(0, attributeText_french.length))

            frenchString.enumerateSubstrings(in: frenchString.startIndex..<frenchString.endIndex, options: .byWords) {
                (substring, substringRange, _, _) in
                if (substring == "JE" || substring == "VOUS" || substring == "REMERCIE"){
                    attributeText_french.addAttribute(.foregroundColor, value: UIColor.black,
                                                      range: NSRange(substringRange, in: frenchString))
                    
                    attributeText_french.addAttribute(.font, value: UIFont(name: "Helvetica-Bold", size: 110.0)!, range: NSRange(substringRange, in: frenchString))
                }
            }
            infoLabel.attributedText = attributeText_french
            finishedButton.setTitle("FINI", for: UIControlState.normal)

        
        }
        else {
            let englishString: String = "THANK \n YOU \n PLEASE SEE THE \n MILWAUKEE REPRESENTATIVE TO CLAIM YOUR GOOD"
            let attributeText_english = NSMutableAttributedString.init(string: englishString)
            attributeText_english.addAttribute(.foregroundColor, value: UIColor.red,
                                              range: NSMakeRange(0, attributeText_english.length))
            attributeText_english.addAttribute(.font, value: UIFont(name: "Helvetica-Bold", size: 85.0)!, range: NSMakeRange(0, attributeText_english.length))
            
            englishString.enumerateSubstrings(in: englishString.startIndex..<englishString.endIndex, options: .byWords) {
                (substring, substringRange, _, _) in
                if (substring == "THANK" || substring == "YOU") {
                    attributeText_english.addAttribute(.foregroundColor, value: UIColor.black,
                                                      range: NSRange(substringRange, in: englishString))
                    
                    attributeText_english.addAttribute(.font, value: UIFont(name: "Helvetica-Bold", size: 110.0)!, range: NSRange(substringRange, in: englishString))
                }
            }
            infoLabel.attributedText = attributeText_english
            finishedButton.setTitle("FINISHED", for: UIControlState.normal)

        }
   
    }
    
    @objc func navigateToEnterNowScreen() {
        timer.invalidate()
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func finshedButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
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
