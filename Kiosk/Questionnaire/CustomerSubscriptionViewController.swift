//
//  CustomerSubscriptionViewController.swift
//  Kiosk
//
//  Created by Mohini Mehetre on 18/03/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import UIKit
import BFPaperCheckbox
import DropDown
import MagicalRecord
import SafariServices
import Alamofire


class CustomerSubscriptionViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var viewForNewsletterCheckbox: UIView!
    @IBOutlet weak var viewForEmailCheckbox: UIView!
        
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var lblTrade: UILabel!
    @IBOutlet weak var lblLanguagePreference: UILabel!
    @IBOutlet weak var txtEmailAddress: UITextField!

    @IBOutlet weak var languageSelectorView: UIView!
    @IBOutlet weak var xConstraintForSelectorView: NSLayoutConstraint!
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet weak var btnFrench: UIButton!
    
    @IBOutlet weak var lblNewsLetterAgreement: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnVisitMilwaukeeSite: UIButton!
    
    @IBOutlet weak var firstNameTopConstarint: NSLayoutConstraint!
    
    //MARK: - Properties
    var acceptsNewsLetter = false
    var acceptsEmails = false
    var acceptsDistributorEmail = false
    var selectedTrade : String?
    var availableLanguages = [LanguagePreference(name: "English", localeCode: "EN"), LanguagePreference(name: "French", localeCode: "FR")]
    var selectedLanguage : LanguagePreference!
    
    var selectedLanguagePreference : String?
    
    
    var tradeDropDown = DropDown()
    var hearAboutDropDown = DropDown()
    
    var checkboxForNewsletterAgreement : BFPaperCheckbox!
        
    var frenchTrades = ["Mécanique d'auto/avion/équipement",
                        "Charpentier",
                        "DIY",
                        "Drywall/Ceiling Installer",
                        "Électricien",
                        "Entretien / réparation d'installation",
                        "Ferme/Ranch/Agriculture",
                        "Maçonnerie/Béton",
                        "Climatisation et réfrigération",
                        "Travail des métaux",
                        "Tuyauteur",
                        "Plombier",
                        "Utilitaire d'alimentation",
                        "Rénovation",
                        "Autre"]
    
    var englishTrades = ["Auto/Aircraft/Equip. Mechanics/Repair",
                         "Carpenter",
                         "DIY",
                         "Drywall/Ceiling Installer",
                         "Electrician",
                         "Facility Maintenance/Repair",
                         "Farm/Ranch/Agriculture",
                         "Masonry/Concrete",
                         "Mechanical & HVACR",
                         "Metalworking",
                         "Pipe, Steam & Sprinkler Fitter",
                         "Plumber",
                         "Power Utility",
                         "Remodeler",
                         "Other"]
    
    var englishLanguagePreferences = ["English",
                             "French"]
    var frenchLanguagePreferences = ["Anglais",
                            "français",
                            ]
    
    
    //MARK: - Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        selectedLanguage = availableLanguages.first
        //configure UI according to selected language here
        
        setupCheckBox()
        englishTapped(btnEnglish)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: - Other functions
    
    func setupCheckBox() {
        
        checkboxForNewsletterAgreement = self.createCheckBoxView(size: viewForNewsletterCheckbox.frame.size)
        checkboxForNewsletterAgreement.delegate = self
        self.viewForNewsletterCheckbox.addSubview(checkboxForNewsletterAgreement)
    }
    
    func validate() -> Bool {
        
        if (txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            txtFirstName.text = ""
            txtFirstName.becomeFirstResponder()
            return false
        } else if (txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            txtLastName.text = ""
            txtLastName.becomeFirstResponder()
            return false
        } else if (txtPostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            txtPostalCode.text = ""
            txtPostalCode.becomeFirstResponder()
            return false
        } else if selectedTrade == nil {
            self.tradeDropdownTapped(lblTrade)
            return false
        }
        else if selectedLanguagePreference == nil {
            self.showLanguagePreferenceDropdown(lblLanguagePreference)
            return false
        }else if ((txtEmailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! || !(txtEmailAddress.text?.isValidEmail())!) {
            txtEmailAddress.text = ""
            txtEmailAddress.becomeFirstResponder()
            return false
        }
        else if !acceptsNewsLetter {
            
            let acceptNewsletterController : UIAlertController
            
            if selectedLanguage.localeCode == "EN" {
                acceptNewsletterController = UIAlertController(title: "Milwaukee", message: "In order to submit, you must agree to receive the Milwaukee Tool Newsletter.", preferredStyle: .alert)
            } else {
                acceptNewsletterController = UIAlertController(title: "Milwaukee", message: "Pour soumettre, vous devez accepter de recevoir le bulletin de Milwaukee Tools.", preferredStyle: .alert)
            }
            
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.lblNewsLetterAgreement.center.x - 10, y: self.lblNewsLetterAgreement.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: self.lblNewsLetterAgreement.center.x + 10, y: self.lblNewsLetterAgreement.center.y))
                
                self.lblNewsLetterAgreement.layer.add(animation, forKey: "position")
                
            };
            
            acceptNewsletterController.addAction(okAction)
            self.present(acceptNewsletterController, animated: true)
            return false
        }
        
        return true
    }
    
    func setLanguage(to language : LanguagePreference) {
        selectedLanguage = language
        localize()
    }
    
    func localize() {
        
        let isFrench = selectedLanguage.localeCode == "FR"
        
        if !isFrench {
            
            txtFirstName.placeholder = "FIRST NAME"
            txtLastName.placeholder = "LAST NAME"
            txtPostalCode.placeholder = "POSTAL CODE"
            if let selectedTrade = selectedTrade{
                
                if let index = englishTrades.index(of: selectedTrade){
                    lblTrade.text = englishTrades[index]
                } else if let index = frenchTrades.index(of: selectedTrade){
                    lblTrade.text = englishTrades[index]
                }
                
            } else {
                lblTrade.text = "TRADE"
            }
            
            if let selectedLanguagePreference = selectedLanguagePreference{
                
                if let index = englishLanguagePreferences.index(of: selectedLanguagePreference){
                    lblLanguagePreference.text = englishLanguagePreferences[index]
                } else if let index = frenchLanguagePreferences.index(of: selectedLanguagePreference){
                    lblLanguagePreference.text = englishLanguagePreferences[index]
                }
                
            } else {
                lblLanguagePreference.text = "LANGUAGE PREFERENCE".uppercased()
            }
            
            lblNewsLetterAgreement.text = "I agree to receive Milwaukee Tools newsletter containing, news, updates, and promotions. You can unsubscribe at any time"
            
            btnSubmit.setTitle("NEXT FORM", for: .normal)
            btnVisitMilwaukeeSite.setTitle("VISIT MILWAUKEE WEBSITE", for: .normal)
            
        } else {
            
            txtFirstName.placeholder = "Prénom".uppercased()
            txtLastName.placeholder = "Nom de famille".uppercased()
            txtPostalCode.placeholder = "code postal".uppercased()
            
            if let selectedTrade = selectedTrade{
                if let index = englishTrades.index(of: selectedTrade){
                    lblTrade.text = frenchTrades[index]
                } else if let index = frenchTrades.index(of: selectedTrade){
                    lblTrade.text = frenchTrades[index]
                }
            } else {
                lblTrade.text = "Métier".uppercased()
            }
            //refactor
            if let selectedLanguagePreference = selectedLanguagePreference{
                if let index = englishLanguagePreferences.index(of: selectedLanguagePreference){
                    lblLanguagePreference.text = frenchLanguagePreferences[index]
                } else if let index = frenchLanguagePreferences.index(of: selectedLanguagePreference){
                    lblLanguagePreference.text = frenchLanguagePreferences[index]
                }
            } else {
                lblLanguagePreference.text = "PRÉFÉRENCE DE LANGUE".uppercased()
            }
            
            lblNewsLetterAgreement.text = "J'accepte de recevoir des infolettres de la part de Milwaukee Tools, pouvant contenir des actualités, des mises à jour et des promotions. Vous pouvez vous désinscrire à tout moment."
            
            btnSubmit.setTitle("FORMULAIRE SUIVANT", for: .normal)
            btnVisitMilwaukeeSite.setTitle("VISITEZ LE SITE MILWAUKEE", for: .normal)
            
        }
        
    }
    
    
    func reset() {
        
        txtFirstName.text = ""
        txtLastName.text = ""
        txtPostalCode.text = ""
        lblTrade.text = "TRADE"
        lblTrade.textColor = UIColor(white: 153.0/255.0, alpha: 1.0)
        self.lblLanguagePreference.textColor = UIColor(white: 153.0/255.0, alpha: 1.0)
        selectedTrade = nil
        selectedLanguagePreference = nil
        englishTapped(btnEnglish)
        
        checkboxForNewsletterAgreement.uncheck(animated: true)
        acceptsNewsLetter = false
        
        acceptsEmails = false
        
        acceptsDistributorEmail = false
    }
    
    func presentWinnerSelectionScreen () {
        
        let winnerSelectionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WinnerSelectionViewController") as! WinnerSelectionViewController
        self.present(winnerSelectionController, animated: true)
        
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return true;
    }
    
    
    // MARK: - IBAction
    
    @IBAction func englishTapped(_ sender: Any) {
        setLanguage(to: availableLanguages.first!)
        
        let button = sender as! UIButton
        let originForSelector = button.superview?.convert(button.frame.origin, to: self.view)
        self.xConstraintForSelectorView.constant = originForSelector!.x
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        self.btnEnglish.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.btnFrench.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        UserDefaults.standard.set("EN", forKey: Constant.UserDefaultKey.languagePreference)
    }
    
    @IBAction func frenchTapped(_ sender: Any) {
        setLanguage(to: availableLanguages.last!)
        
        let button = sender as! UIButton
        let originForSelector = button.superview?.convert(button.frame.origin, to: self.view)
        self.xConstraintForSelectorView.constant = originForSelector!.x
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        self.btnFrench.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.btnEnglish.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        UserDefaults.standard.set("FR", forKey: Constant.UserDefaultKey.languagePreference)
    }

    
    @IBAction func showLanguagePreferenceDropdown(_ sender: Any) {
        
        self.configure(hearAboutDropDown, dataSource: selectedLanguage.localeCode == "EN" ? englishLanguagePreferences : frenchLanguagePreferences, sourceView : sender as! UIView) {[weak self] (index, selectedLanguagePreference) in
            self?.selectedLanguagePreference = selectedLanguagePreference
            self?.lblLanguagePreference.text = selectedLanguagePreference
            self?.lblLanguagePreference.textColor = UIColor(white: 0.0, alpha: 1.0)
        }
    }
    
    
    @IBAction func tradeDropdownTapped(_ sender: Any) {
        
        self.configure(tradeDropDown, dataSource: selectedLanguage.localeCode == "EN" ? englishTrades : frenchTrades, sourceView : sender as! UIView) {[weak self] (index, strSelectedTrade) in
            self?.selectedTrade = strSelectedTrade
            self?.lblTrade.text = strSelectedTrade
            self?.lblTrade.textColor = UIColor(white: 0.0, alpha: 1.0)
        }
        
    }
    
    private func configure(_ dropDown: DropDown, dataSource: [String], sourceView: UIView, selection: @escaping SelectionClosure ) {
        self.view.endEditing(true)
        dropDown.dataSource = dataSource
        dropDown.anchorView = sourceView
        dropDown.selectionAction = selection
        dropDown.show()
    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if validate() {
            
            self.view.endEditing(true)
            
            /*
            let subscriptionEntry = SubscriptionEntry.mr_createEntity()!
            subscriptionEntry.copy(withFirstname: txtFirstName.text!, lastName: txtLastName.text!, email: txtPostalCode.text!, postalCode: "", trade: selectedTrade!, hearAbout: lblLanguagePreference.text ?? "", language: selectedLanguage!, acceptsNewsLetter: acceptsNewsLetter, acceptsEmails: acceptsEmails, coordinates : LocationService.shared.getCurrentCoordinates() ?? (0.0, 0.0),isReceiveDistributorEmails: acceptsDistributorEmail)
            NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
            */
            
            //Show progress hud
            self.showHUD(progressLabel: "")
            
            let parameters = ["firstName":self.txtFirstName.text!,
                              "lastName":self.txtLastName.text!,
                              "email":self.txtEmailAddress.text!,
                              "language": (self.lblLanguagePreference.text! == "English") ? "EN" : "FR",
                              "postalCode": self.txtPostalCode.text!,
                              "trade": self.lblTrade.text!,
                              "deviceID": DeviceUniqueIDManager.shared.uniqueID]
            
            let surveyId = UserDefaults.standard.value(forKey: "moduleTypeID")

            KioskNetworkManager.shared.submitEntryInfo(surveyId: surveyId as! Int, parameter: parameters) { (reponseObject) in
                
                // hiding progress hud
                self.dismissHUD(isAnimated: true)
                
                if reponseObject != nil {
                 
                    let entryId = reponseObject!["id"] as? Int
                    
                    UserDefaults.standard.set(entryId, forKey: "entryID")
                    UserDefaults.standard.synchronize()
                    
                    self.performSegue(withIdentifier: "segueToQuestionnaire", sender: self)

                    /*
                    let successAlertController : UIAlertController
                    let doneAction : UIAlertAction
                    
                    if self.selectedLanguage.localeCode == "EN" {
                        
                        successAlertController = UIAlertController(title: "Thank you!", message: "Thank you for entering. Please look out for an email from Milwaukee Tool to confirm your submission.", preferredStyle: .alert)
                        
                        doneAction = UIAlertAction(title: "Done", style: .default){ action in
                            
                            self.performSegue(withIdentifier: "segueToQuestionnaire", sender: self)
                            
                        };
                        
                    }
                    else {
                        
                        successAlertController = UIAlertController(title: "Merci!", message: "Merci d'être entré. S'il vous plaît regarder pour un email de Milwaukee Tool pour confirmer votre soumission", preferredStyle: .alert)
                        
                        doneAction = UIAlertAction(title: "Terminé", style: .default){ action in
                            
                            self.performSegue(withIdentifier: "segueToQuestionnaire", sender: self)
                            
                        };
                    }
                    
                    successAlertController.addAction(doneAction)
                    
                    self.present(successAlertController, animated: true, completion: nil)
                    */
                    
                    self.reset()
                    
                    SyncEngine.shared.startEngine()
                    
                } else {
                    
                    let networkAlert = UIAlertController(title: "Milwaukee", message: "Error in Submitting Entry", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { action in
                        self.dismiss(animated: true)
                    }
                    networkAlert.addAction(okAction)
                    self.present(networkAlert, animated: true)
                    
                }
            }
        }
        
    }

    @IBAction func visitMilwaukeeSiteTapped(_ sender: Any) {
        
        let milwaukeeSiteViewController = SFSafariViewController(url: URL(string: "https://www.milwaukeetool.ca/")!)
        milwaukeeSiteViewController.navigationItem.setRightBarButtonItems([], animated: true)
        self.present(milwaukeeSiteViewController, animated: true){
            let width: CGFloat = 130
            let x: CGFloat = self.view.frame.width - width
            
            // It can be any overlay. May be your logo image here inside an imageView.
            let overlay = UIView(frame: CGRect(x: x, y: 20, width: width, height: 44))
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            milwaukeeSiteViewController.view.addSubview(overlay)
        }
    }
    
    @IBAction func youtubeTapped(_ sender: Any) {
        
        //https://www.youtube.com/channel/UC3dc-rblU34e6AhSWHInPMg
        
        //        let youtubeViewController = SFSafariViewController(url: URL(string: "https://www.youtube.com/channel/UC3dc-rblU34e6AhSWHInPMg")!)
        //        youtubeViewController.navigationItem.setRightBarButtonItems([], animated: true)
        //        self.present(youtubeViewController, animated: true){
        //            let width: CGFloat = 130
        //            let x: CGFloat = self.view.frame.width - width
        //
        //            // It can be any overlay. May be your logo image here inside an imageView.
        //            let overlay = UIView(frame: CGRect(x: x, y: 20, width: width, height: 44))
        //            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        //            youtubeViewController.view.addSubview(overlay)
        //        }
        
    }
    
    private func createCheckBoxView(size: CGSize) -> BFPaperCheckbox {
        
        var checkboxForNewsletterAgreement = BFPaperCheckbox(frame: CGRect(x: 0,
                                                                           y: 0,
                                                                           width: size.width,
                                                                           height: size.height))
        checkboxForNewsletterAgreement.tintColor = UIColor(red: 97, green: 97, blue: 97, alpha: 1)
        checkboxForNewsletterAgreement.touchUpAnimationDuration = 0.5
        checkboxForNewsletterAgreement.touchDownAnimationDuration = 0.5
        checkboxForNewsletterAgreement.rippleFromTapLocation = false
        checkboxForNewsletterAgreement.checkmarkColor = UIColor.blue
        checkboxForNewsletterAgreement.positiveColor = UIColor.lightGray.withAlphaComponent(0.5)
        checkboxForNewsletterAgreement.negativeColor = UIColor.lightGray.withAlphaComponent(0.5)
        checkboxForNewsletterAgreement.startDiameter = 10
        checkboxForNewsletterAgreement.endDiameter = 35
        checkboxForNewsletterAgreement.burstAmount = 10
        return checkboxForNewsletterAgreement
    }
    
    
}

//MARK: - BFPaperCheckboxDelegate

extension CustomerSubscriptionViewController : BFPaperCheckboxDelegate {
    func paperCheckboxChangedState(_ checkbox: BFPaperCheckbox!) {
        
        if checkbox == checkboxForNewsletterAgreement {
            acceptsNewsLetter = checkbox.isChecked
        } else {
            acceptsDistributorEmail = checkbox.isChecked
        }
        
    }
}


