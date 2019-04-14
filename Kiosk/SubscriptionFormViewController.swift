//
//  SubscriptionFormViewController.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 15/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import UIKit
import BFPaperCheckbox
import DropDown
import MagicalRecord
import SafariServices
import AVKit
import Alamofire

/*
 ·         Auto/Aircraft/Equip. Mechanics/Repair
 ·         Carpenter
 ·         DIY
 ·         Drywall/Ceiling Installer
 ·         Electrician
 ·         Facility Maintenance/Repair
 ·         Farm/Ranch/Agriculture
 ·         Masonry/Concrete
 ·         Mechanical & HVACR
 ·         Metalworking
 ·         Pipe, Steam & Sprinkler Fitter
 ·         Plumber
 ·         Power Utility
 ·         Remodeler
 ·         Other
 */

enum TradeOptions {
    case
    AirCraftRepair,
    Carpenter,
    DIY,
    DrywallCeilingInstaller,
    Electrician,
    FacilityMaintenanceRepair,
    FarmRanchAgriculture,
    MasonryConcrete,
    Mechanical_HVACR,
    Metalworking,
    Fitter,
    Plumber,
    PowerUtility,
    Remodeler,
    Other
}

struct LanguagePreference {
    let name : String
    let localeCode : String
}



class SubscriptionFormViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var viewForNewsletterCheckbox: UIView!
    @IBOutlet weak var viewForEmailCheckbox: UIView!
    
    @IBOutlet weak var distributorEmailCheckBoxView: UIView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblTrade: UILabel!

    @IBOutlet weak var languageSelectorView: UIView!
    @IBOutlet weak var xConstraintForSelectorView: NSLayoutConstraint!
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet weak var btnFrench: UIButton!
    
    @IBOutlet weak var lblNewsLetterAgreement: UILabel!
    @IBOutlet weak var lblEmailAgreement: UILabel!
    @IBOutlet weak var distributedEmailAgreementLabel: UILabel!
    
    @IBOutlet weak var btnContestRules: UIButton!
    @IBOutlet weak var lblContestRules: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnVisitMilwaukeeSite: UIButton!
    // hear about view outlets
    @IBOutlet weak var hearAboutLabel: UILabel!
    @IBOutlet weak var hearAboutContainerView: UIView!
    
    @IBOutlet weak var firstNameTopConstarint: NSLayoutConstraint!
    
    //MARK: - Properties
    var acceptsNewsLetter = false
    var acceptsEmails = false
    var acceptsDistributorEmail = false
    var selectedTrade : String?
    var availableLanguages = [LanguagePreference(name: "English", localeCode: "EN"), LanguagePreference(name: "French", localeCode: "FR")]
    var selectedLanguage : LanguagePreference!
    
    var selectedHearAbout : String?

    
    var tradeDropDown = DropDown()
    var hearAboutDropDown = DropDown()

    var checkboxForNewsletterAgreement : BFPaperCheckbox!
    var checkboxForEmailAgreement : BFPaperCheckbox!
    var checkboxForDistributorEmail : BFPaperCheckbox!

    var screenSaverPlayer = AVPlayerViewController()
    
    var numberOfLogoTaps = 0
    
    var frenchTrades = ["Mécanique d'auto/avion/équipement",
                        "Charpentier",
                        "DIY",
                        "Installateur de cloisons sèches / plafonds",
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
    
    var englishHearAbouts = ["Radio",
                         "Online Advertisement",
                         "In Store Advertisement/Staff",
                         "Milwaukee Rep",
                         "Word of Mouth",
                         "Other"]
    var frenchHearAbouts = ["Radio",
                            "Publicité en ligne",
                             "Publicité en magasin / personnel",
                             "Milwaukee Rep",
                             "Bouche à oreille",
                             "Autre"]
    
    
    //MARK: - Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        selectedLanguage = availableLanguages.first
        //configure UI according to selected language here
        
        setupCheckBox()
        configureContestUI()
        englishTapped(btnEnglish)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleIdleDevice),
                                               name: .appIsIdle,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAppActivity),
                                               name: .appDetectedUserTouch,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.screenSaverPlayer.player?.currentItem)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newScreenSaverUpdated),
                                               name: .updatedScreenSaver,
                                               object: nil)
        
        self.showHearAboutView()
        
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
        
        //checkboxForEmailAgreement
        checkboxForEmailAgreement = self.createCheckBoxView(size: viewForEmailCheckbox.frame.size)
        checkboxForEmailAgreement.delegate = self;
        self.viewForEmailCheckbox.addSubview(checkboxForEmailAgreement)
        
        checkboxForDistributorEmail = self.createCheckBoxView(size: distributorEmailCheckBoxView.frame.size)
        checkboxForDistributorEmail.delegate = self
        distributorEmailCheckBoxView.addSubview(checkboxForDistributorEmail)
        
        distributorEmailCheckBoxView.isHidden = !ScreenSaver.shouldShownDistributorCheckBox()
        distributedEmailAgreementLabel.isHidden = !ScreenSaver.shouldShownDistributorCheckBox()
        
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
        } else if (txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            txtEmail.text = ""
            txtEmail.becomeFirstResponder()
            return false
        } else if !(txtEmail.text?.isValidEmail())! {
            txtEmail.becomeFirstResponder()
            return false
        } else if selectedTrade == nil {
            self.tradeDropdownTapped(lblTrade)
            return false
        }else if selectedHearAbout == nil && UserDefaults.standard.bool(forKey: Constant.UserDefaultKey.shouldShowHearedAbout) {
            self.showHearAboutDropdown(hearAboutLabel)
            return false
        } else if !acceptsNewsLetter {
            
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
            txtEmail.placeholder = "E-MAIL"
            if let selectedTrade = selectedTrade{
                
                if let index = englishTrades.index(of: selectedTrade){
                    lblTrade.text = englishTrades[index]
                } else if let index = frenchTrades.index(of: selectedTrade){
                    lblTrade.text = englishTrades[index]
                }
                
            } else {
                lblTrade.text = "TRADE"
            }
            
            if let selectedHearAbout = selectedHearAbout{
                
                if let index = englishHearAbouts.index(of: selectedHearAbout){
                    hearAboutLabel.text = englishHearAbouts[index]
                } else if let index = frenchHearAbouts.index(of: selectedHearAbout){
                    hearAboutLabel.text = englishHearAbouts[index]
                }
                
            } else {
                hearAboutLabel.text = "How Did You Hear About The Event?".uppercased()
            }
            
            lblNewsLetterAgreement.text = "I agree to receive Milwaukee Tools newsletter containing, news, updates, and promotions. You can unsubscribe at any time"
            lblEmailAgreement.text = "Yes, I would like to receive emails about Milwaukee promotions, events and other news via my Store Representative."
            
            btnSubmit.setTitle("SUBMIT", for: .normal)
            lblContestRules.text = "By tapping submit, you agree to the contest rules"
            btnContestRules.setTitle("CONTEST RULES", for: .normal)
            btnVisitMilwaukeeSite.setTitle("VISIT MILWAUKEE WEBSITE", for: .normal)
            
        } else {
            
            txtFirstName.placeholder = "Prénom".uppercased()
            txtLastName.placeholder = "Nom de famille".uppercased()
            txtEmail.placeholder = "Courriel".uppercased()
            
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
            if let selectedHearAbout = selectedHearAbout{
                if let index = englishHearAbouts.index(of: selectedHearAbout){
                    hearAboutLabel.text = frenchHearAbouts[index]
                } else if let index = frenchHearAbouts.index(of: selectedHearAbout){
                    hearAboutLabel.text = frenchHearAbouts[index]
                }
            } else {
                hearAboutLabel.text = "Comment avez-vous entendu parler de l'événement".uppercased()
            }
            
            
            lblNewsLetterAgreement.text = "J'accepte de recevoir des infolettres de la part de Milwaukee Tools, pouvant contenir des actualités, des mises à jour et des promotions. Vous pouvez vous désinscrire à tout moment."
            lblEmailAgreement.text = "Oui, j'aimerais recevoir des courriels à propos des promotions, événements et autres nouvelles de Milwaukee par l'intermédiaire de mon représentant de magasin."
            
            btnSubmit.setTitle("ENVOYER", for: .normal)
            lblContestRules.text = "En appuyant sur \"Envoyer\", vous acceptez les règles du concours."
            btnContestRules.setTitle("RÈGLES DU CONCOURS.", for: .normal)
            btnVisitMilwaukeeSite.setTitle("VISITEZ LE SITE MILWAUKEE", for: .normal)
            
        }
        
    }
    
    
    func reset() {
        
        txtFirstName.text = ""
        txtLastName.text = ""
        txtEmail.text = ""
        lblTrade.text = "TRADE"
        lblTrade.textColor = UIColor(white: 153.0/255.0, alpha: 1.0)
        self.hearAboutLabel.textColor = UIColor(white: 153.0/255.0, alpha: 1.0)
        selectedTrade = nil
        selectedHearAbout = nil
        englishTapped(btnEnglish)
        
        checkboxForNewsletterAgreement.uncheck(animated: true)
        acceptsNewsLetter = false
        
        checkboxForEmailAgreement.uncheck(animated: true)
        acceptsEmails = false
        
        checkboxForDistributorEmail.uncheck(animated: true)
        acceptsDistributorEmail = false
        
    }
    
    @objc func handleIdleDevice() {
        reset()
        
        SyncEngine.shared.startEngine()
        
        numberOfLogoTaps = 0
        
        if let somePresentingController = self.presentedViewController {
            somePresentingController.dismiss(animated: true) {
                DispatchQueue.main.async {
                    self.presentScreenSaver()
                }
            }
        } else {
            self.presentScreenSaver()
        }
    }
    
    @objc func handleAppActivity() {
        
        self.screenSaverPlayer.player?.pause()
        self.screenSaverPlayer.player = nil
        
        if let somePresentingController = self.presentedViewController {
            
            if somePresentingController == screenSaverPlayer {
                somePresentingController.dismiss(animated: false, completion: nil)
            }
        }
        
    }
    
    @objc func newScreenSaverUpdated() {
        
        configureContestUI()
        
        if let _ = self.presentedViewController as? AVPlayerViewController {
            _ = configureScreenSaverPlayer()
        }
    }
    
    func configureContestUI() {
        let isContest = ScreenSaver.isCurrentScreenSaverAContest()
        lblContestRules.isHidden = !isContest
        btnContestRules.isHidden = !isContest
    }
    
    func presentScreenSaver() {
        
        guard configureScreenSaverPlayer () else {
            return
        }
        
        self.present(screenSaverPlayer, animated: true) {
            self.screenSaverPlayer.player?.play()
        }
    }
    
    func configureScreenSaverPlayer() -> Bool {
        
        guard let url = ScreenSaver.getUrlForScreensaver() else { return false }
        
        screenSaverPlayer.player?.pause()
        screenSaverPlayer.player = AVPlayer(url: url)
        screenSaverPlayer.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        screenSaverPlayer.entersFullScreenWhenPlaybackBegins = true
        screenSaverPlayer.showsPlaybackControls = false
        screenSaverPlayer.player?.play()
        return true
    }
    
    func presentWinnerSelectionScreen () {
        
        let winnerSelectionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WinnerSelectionViewController") as! WinnerSelectionViewController
        winnerSelectionController.delegate = self
        self.present(winnerSelectionController, animated: true)
        
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.screenSaverPlayer.player?.seek(to: kCMTimeZero)
        self.screenSaverPlayer.player?.play()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueToContestRules"{
            
            let urlToContestRules = ScreenSaver.getUrlForContestRules()
            let contestRulesViewController = segue.destination as! ContestRulesViewController
            contestRulesViewController.contestUrl = urlToContestRules
            
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "segueToContestRules"{
            return ScreenSaver.getUrlForContestRules() != nil
        }
        
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
        
    }
    
    @IBAction func frenchTapped(_ sender: Any) {
        setLanguage(to: availableLanguages.last!)
        
        let button = sender as! UIButton
        let originForSelector = button.superview?.convert(button.frame.origin, to: self.view)
        self.xConstraintForSelectorView.constant = originForSelector!.x
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
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
                    self.presentWinnerSelectionScreen()
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { cancelAction in
                
            }
            
            masterPasswordAlertController.addAction(submitAction)
            masterPasswordAlertController.addAction(cancelAction)
            
            self.present(masterPasswordAlertController, animated: true)
            
        }
        
        
    }
    
    @IBAction func showHearAboutDropdown(_ sender: Any) {
        
        self.configure(hearAboutDropDown, dataSource: selectedLanguage.localeCode == "EN" ? englishHearAbouts : frenchHearAbouts, sourceView : sender as! UIView) {[weak self] (index, selectedHearAbout) in
            self?.selectedHearAbout = selectedHearAbout
            self?.hearAboutLabel.text = selectedHearAbout
            self?.hearAboutLabel.textColor = UIColor(white: 0.0, alpha: 1.0)
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
            
            let subscriptionEntry = SubscriptionEntry.mr_createEntity()!
            subscriptionEntry.copy(withFirstname: txtFirstName.text!, lastName: txtLastName.text!, email: txtEmail.text!, postalCode: "", trade: selectedTrade!, hearAbout: hearAboutLabel.text ?? "", language: selectedLanguage!, acceptsNewsLetter: acceptsNewsLetter, acceptsEmails: acceptsEmails, coordinates : LocationService.shared.getCurrentCoordinates() ?? (0.0, 0.0),isReceiveDistributorEmails: acceptsDistributorEmail)
            NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
            
            let successAlertController : UIAlertController
            let doneAction : UIAlertAction
            
            if selectedLanguage.localeCode == "EN" {
                successAlertController = UIAlertController(title: "Thank you!", message: "Thank you for entering. Please look out for an email from Milwaukee Tool to confirm your submission.", preferredStyle: .alert)
                doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
            } else {
                successAlertController = UIAlertController(title: "Merci!", message: "Merci d'être entré. S'il vous plaît regarder pour un email de Milwaukee Tool pour confirmer votre soumission", preferredStyle: .alert)
                doneAction = UIAlertAction(title: "Terminé", style: .default, handler: nil)
            }
            
            successAlertController.addAction(doneAction)
            
            self.present(successAlertController, animated: true, completion: nil)
            
            reset()
            
            SyncEngine.shared.startEngine()
        }
        
    }
    
    @IBAction func contestRulesTapped(_ sender: Any) {
        
        
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
    
    private func showHearAboutView() {
        let shouldShown = UserDefaults.standard.bool(forKey: Constant.UserDefaultKey.shouldShowHearedAbout)
        if shouldShown {
            hearAboutContainerView.isHidden = false
            firstNameTopConstarint.constant = 20;
        } else {
            hearAboutContainerView.isHidden = true
            firstNameTopConstarint.constant = 86;
            
        }
        
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

extension SubscriptionFormViewController : BFPaperCheckboxDelegate {
    func paperCheckboxChangedState(_ checkbox: BFPaperCheckbox!) {
        
        if checkbox == checkboxForNewsletterAgreement {
            acceptsNewsLetter = checkbox.isChecked
        } else if checkbox == checkboxForEmailAgreement {
            acceptsEmails = checkbox.isChecked
        } else {
            acceptsDistributorEmail = checkbox.isChecked
        }
        
    }
}

extension SubscriptionFormViewController: WinnerSelectionViewControllerDelegate {
    func changedSetting() {
        self.showHearAboutView()
    }
    
}


