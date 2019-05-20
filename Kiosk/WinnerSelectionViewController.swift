//
//  WinnerSelectionViewController.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 01/05/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import UIKit
import DropDown
import SafariServices


protocol WinnerSelectionViewControllerDelegate: class {
    func changedSetting()
}


class WinnerSelectionViewController: UIViewController {

    //MARK: - IBOutlets
    var isFromSurveyMode: Bool? = false
    @IBOutlet weak var screenBackground: UIImageView!
    @IBOutlet weak var showHeadAboutLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    
    @IBOutlet weak var totalWinnerLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var btnShowWinner: UIButton!
    
    @IBOutlet weak var dateRangeSelectionView: UIView!
    @IBOutlet weak var winnerDisplayView: UIView!
    
    @IBOutlet weak var imageViewForSpinner: UIImageView!
    @IBOutlet weak var lblWinner: LTMorphingLabel!
    @IBOutlet weak var btnChangeDeviceName: UIButton!
    
    @IBOutlet weak var hearAboutSwitch: UISwitch!
    
    //Winner view outlets and variables
    var totalWinnerDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = ["1","2","3","4","5"]
        return dropDown
    }()
    var totalWinner = 1
    //delegate
    weak var delegate: WinnerSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startDatePicker.backgroundColor = UIColor.white
        endDatePicker.backgroundColor = UIColor.white
        
        winnerDisplayView.isHidden = true
        dateRangeSelectionView.isHidden = false

        setupSpinner()
        
        lblWinner.morphingEffect = .burn
        hearAboutSwitch.isOn = UserDefaults.standard.bool(forKey: Constant.UserDefaultKey.shouldShowHearedAbout)
        
        if (isFromSurveyMode!)
        {
            self.screenBackground.alpha = 1
            self.screenBackground.image = UIImage.init(named: "QuesionaireBackground")
            
            self.btnChangeDeviceName.setTitleColor(UIColor.black, for:.normal)
            self.closeButton.setTitleColor(UIColor.black, for:.normal)

            self.totalWinnerLabel.textColor = UIColor.black
            self.totalWinnerLabel.backgroundColor = UIColor.clear
            
            self.showHeadAboutLabel.isHidden = true
            self.hearAboutSwitch.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (isFromSurveyMode!)
        {
            self.btnChangeDeviceName.isHidden = false
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueToNameChange" {
            
            if let deviceNameChangeViewController = segue.destination as? DeviceRegistrationViewController{
                deviceNameChangeViewController.isFromSetting = true
            }
            
        }
    }
    
    
    //MARK: - Other functions
    
    func setupSpinner() {
        
        var frames : [UIImage] = []
        
        for number in 0...19 {
            let nameOfImage = "frame_\(number)"
            let image = UIImage(named: nameOfImage)!
            frames.append(image)
        }
        
        imageViewForSpinner.animationImages = frames
        imageViewForSpinner.animationDuration = 1
        imageViewForSpinner.animationRepeatCount = 0
        imageViewForSpinner.startAnimating()
        
    }
    
    
    //MARK: - IBActions
    
    @IBAction func startDateChanged(_ sender: UIDatePicker) {
        
        endDatePicker.minimumDate = startDatePicker.date
        
    }
    
    @IBAction func endDateChanged(_ sender: UIDatePicker) {
        
        
        
    }
    
    @IBAction func showHearAbout(_ sender: Any) {
        
        UserDefaults.standard.set(self.hearAboutSwitch.isOn, forKey: Constant.UserDefaultKey.shouldShowHearedAbout)
        UserDefaults.standard.synchronize()

        delegate?.changedSetting()
    }
    
    @IBAction func winnerList(_ sender: Any) {
        self.view.endEditing(true)

        totalWinnerDropDown.anchorView = sender as! UIView
        totalWinnerDropDown.selectionAction = {[weak self] (index, count) in
            self?.totalWinner = Int.init(count) ?? 1
            self?.totalWinnerLabel.text = count
        }
        totalWinnerDropDown.show()

    }
    
    
    
    @IBAction func showWinnerTapped(_ sender: Any) {
        
        dateRangeSelectionView.isHidden = true
        btnChangeDeviceName.isHidden = true
        winnerDisplayView.isHidden = false
        
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            
            KioskNetworkManager.shared.getWinner(from: self.startDatePicker.date, to: self.endDatePicker.date, totalWinner: self.totalWinner) {[weak self] winnerInfos in
                
                guard let strongSelf = self else {
                    return
                }
                
                if let chosenWinners = winnerInfos, chosenWinners.count > 0 {
                    
                    strongSelf.winnerDisplayView.isHidden = true
                    strongSelf.dateRangeSelectionView.isHidden = false

                    //self?.winnerDisplayView.bringSubview(toFront: self!.lblWinner)

                    let winnersListViewController =  WinnersListViewController.initWithStoryboard()
                    winnersListViewController.startDate = strongSelf.startDatePicker.date
                    winnersListViewController.endDate = strongSelf.endDatePicker.date
                    winnersListViewController.count = strongSelf.totalWinner
                    winnersListViewController.isFromSurveyMode = self?.isFromSurveyMode
                    let winners = chosenWinners.map({ (winnerDictionary) -> Winner
                        in
                        
                       return  Winner.init(id: winnerDictionary["winnerID"] as! Int, name: (winnerDictionary["firstName"] as! String) + " " + (winnerDictionary["lastName"] as! String) , email: winnerDictionary["email"] as! String)
                    })
                    winnersListViewController.winnersList = winners.sorted(by: { $0.id < $1.id})

                    self?.present(winnersListViewController, animated: true, completion: nil)

//                    let attributedText = NSMutableAttributedString()
//                    for chosenWinner in chosenWinners {
//                        let firstname = chosenWinner["firstName"] as! String
//                        let lastName = chosenWinner["lastName"] as! String
//                        attributedText.append(NSAttributedString.init(string: firstname + " " + lastName))
//                        attributedText.append(NSAttributedString.init(string: "\n"))
//                    }
//
//                    self.lblWinner.attributedText = attributedText.trimmedAttributedString(set: .whitespacesAndNewlines)
                    
                } else {
                    
                    strongSelf.winnerDisplayView.isHidden = true

                    let noWinnerAlertController = UIAlertController(title: "Milwaukee", message: "No entries found during this period.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                        
                        self?.dateRangeSelectionView.isHidden = false
                        self?.winnerDisplayView.isHidden = true
                        self?.btnChangeDeviceName.isHidden = false
                        
                    })
                    noWinnerAlertController.addAction(okAction)
                    self?.present(noWinnerAlertController, animated: true)
                }
                
            }
            
        }
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func dashboard(_ sender: Any) {
        
        
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
    

}
