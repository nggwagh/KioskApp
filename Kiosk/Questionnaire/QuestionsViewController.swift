//
//  ViewController.swift
//  QuestionAnswer
//
//  Created by Nikhil Wagh on 3/16/19.
//  Copyright © 2019 Nikhil Wagh. All rights reserved.
//

import UIKit
import AVKit
import MBProgressHUD
import Alamofire
import AlamofireImage

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - View Lifecycle

    @IBOutlet weak var questionTableView: UITableView!
    
    var allQuestionsArray = [Question]()
    var questionsArray = [Question]()
    var completedQuestionsArray = [Question]()
    var randomIndexArray = [Int]()
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerTextLabel: UILabel!
    
    var screenSaveURLString: String?
    
    var screenSaverViewController = ScreensaverViewController()
    var idleTimer : Timer?
    var countDownTimer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.getQuestionsForSurvey()
        
        self.addObservers()
        
        self.timerView.layer.borderColor = UIColor.black.cgColor
        self.timerView.layer.borderWidth = 1;
        self.timerView.layer.cornerRadius = 10
        
        let languagePreference = UserDefaults.standard.value(forKey: Constant.UserDefaultKey.languagePreference) as! String

        self.timerTextLabel.text = (languagePreference == "EN") ? "Are you still there?" : "Tu es encore la?"
        
    }

    // MARK: - Private Methods
    
    func getQuestionsForSurvey() {
        
        //Show progress hud
        self.showHUD(progressLabel: "")
        
        let surveyId = UserDefaults.standard.value(forKey: "moduleTypeID")
        
        KioskNetworkManager.shared.getQuestions(surveyId: surveyId as! Int) { (responseJson) in
            
            // hiding progress hud
            self.dismissHUD(isAnimated: true)
            
            let response = responseJson
            
            let screenSaver = response!["screensaver"] as? [String : Any]
            
            self.screenSaveURLString = (screenSaver!["url"] as! String)
            
            self.allQuestionsArray = Question.build(from: response!["questions"] as! [[String : Any]])
            
            self.getRandomQuestionFromAllQuestions()

        }
        
    }
    
    
    func getRandomQuestionFromAllQuestions() {
        
        if (self.completedQuestionsArray.count == self.allQuestionsArray.count) {
            
            self.performSegue(withIdentifier: "SegueToThanks", sender: self)
        }
        else {
            
            let randomIndex = Int(arc4random_uniform(UInt32(allQuestionsArray.count)))
            
            if !(randomIndexArray.contains(randomIndex)) {
                
                randomIndexArray.append(randomIndex)
                
                self.questionsArray.append(allQuestionsArray[randomIndex])
                
                self.questionTableView.reloadData()
                
            } else {
                
                self.getRandomQuestionFromAllQuestions()
            }
        }
    }
    
    @objc func updateTime(){
        
        self.timerLabel.text = String(format: "%d", Int(self.timerLabel.text!)! - 1)
        
    }
    
    func invalidateAllTimers(){
        
        if ((countDownTimer != nil) && (idleTimer != nil)) {
            
            countDownTimer!.invalidate()
            idleTimer!.invalidate()
            self.timerView.isHidden = true
            self.timerLabel.text = "20"
        }
       
    }
    
    func submitAnswer(question: Question, answer: Answer){
    
        let surveyId = UserDefaults.standard.value(forKey: "moduleTypeID") as! Int
        
        let entryId = UserDefaults.standard.value(forKey: "entryID") as! Int
        
        let parameters = ["surveyQuestionID":question.questionId,
                          "surveyAnswerID":answer.id,
                          "tries":question.answerSelection!.count]
        
        KioskNetworkManager.shared.submitAnswerDetails(surveyId: surveyId, entryId: entryId, parameter: parameters as! [String : Int]) { (isTrue) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                
                self.completedQuestionsArray.append(question)
                self.questionsArray.removeAll()
                self.questionTableView.reloadData()
                
                self.getRandomQuestionFromAllQuestions()
            })
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (self.questionsArray.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let question = self.questionsArray[section]
        
        if (question.questionType == "Radio") {
            return 2
        }
        
        return (question.questionAnswers?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let question = self.questionsArray[indexPath.section]

        if (question.questionType == "Radio")
        {
            if indexPath.row == 0 {
                
                return UITableViewAutomaticDimension

            }
            
            return 300
        }
        else if (question.questionType == "Single") {
            
            return UITableViewAutomaticDimension

        }
        
       return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let question = self.questionsArray[indexPath.section]
        
        if indexPath.row == 0 {
            
            let questionCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
            
            questionCell.questionLabel.text = question.questionTitle
            
            return questionCell
            
        }
        
        if (question.questionType == "Radio")
        {
        
        let radioAnswerCell = tableView.dequeueReusableCell(withIdentifier: "RadioAnswerCell", for: indexPath) as! RadioAnswerTableViewCell
        
        radioAnswerCell.selectionStyle = .none
        
        // CASE: TRUE
        
        if (question.currentAnswerIsCorrect == "") {
            
            radioAnswerCell.trueButton.setImage(UIImage(named: "True"), for: .normal)
            
        }
        else if ((question.correctAnswer == "True") && (question.currentAnswerIsCorrect == "True")){

            UIView.transition(with: radioAnswerCell.trueButton!, duration: 1.5, options: .transitionFlipFromRight, animations: {
                
                radioAnswerCell.trueButton.setImage(UIImage(named: "Tick"), for: .normal)
            //  radioAnswerCell.trueButton.isUserInteractionEnabled = false

            }, completion: nil)
            
        }
        else if ((question.currentAnswerIsCorrect == "True") && (question.currentAnswerIsCorrect != question.correctAnswer))
        {
            UIView.transition(with: radioAnswerCell.trueButton!, duration: 1.5, options: .transitionFlipFromRight, animations: {
                
                radioAnswerCell.trueButton.setImage(UIImage(named: "Cross"), for: .normal)
            //  radioAnswerCell.trueButton.isUserInteractionEnabled = false


            }, completion: { finished in
                UIView.animate(withDuration: 3.0, animations: {
                    
                    radioAnswerCell.trueButton.setImage(UIImage(named: "TrueGrey"), for: .normal)
            //     radioAnswerCell.trueButton.isUserInteractionEnabled = false
                })
            })
        }
        
        radioAnswerCell.trueButton.addTarget(self, action: #selector(trueButtonAction), for: UIControl.Event.touchUpInside)
        radioAnswerCell.trueButton.tag = indexPath.section
        
        
        
        // CASE: FALSE
        
        if (question.currentAnswerIsCorrect == "") {
            
            radioAnswerCell.falseButton.setImage(UIImage(named: "False"), for: .normal)
            
        }
        else if ((question.correctAnswer == "False") && (question.currentAnswerIsCorrect == "False")) {

            UIView.transition(with: radioAnswerCell.falseButton!, duration: 1.5, options: .transitionFlipFromRight, animations: {
                
                radioAnswerCell.falseButton.setImage(UIImage(named: "Tick"), for: .normal)
            //  radioAnswerCell.falseButton.isUserInteractionEnabled = false

            }, completion: nil)
            
        }
        else if ((question.currentAnswerIsCorrect == "False") && (question.currentAnswerIsCorrect != question.correctAnswer))
        {
            UIView.transition(with: radioAnswerCell.falseButton!, duration: 1.5, options: .transitionFlipFromRight, animations: {
                
                radioAnswerCell.falseButton.setImage(UIImage(named: "Cross"), for: .normal)
           //   radioAnswerCell.falseButton.isUserInteractionEnabled = false

                
            }, completion: { finished in
                UIView.animate(withDuration: 3.0, animations: {
                    
                    radioAnswerCell.falseButton.setImage(UIImage(named: "FalseGrey"), for: .normal)
             //     radioAnswerCell.falseButton.isUserInteractionEnabled = false
                })
            })
        }
        
        radioAnswerCell.falseButton.addTarget(self, action: #selector(falseButtonAction), for: UIControl.Event.touchUpInside)
        radioAnswerCell.falseButton.tag = indexPath.section

        return radioAnswerCell
        
        }
        else if (question.questionType == "Single")
        {
            
            let singleAnswerCell = tableView.dequeueReusableCell(withIdentifier: "SingleAnswerCell", for: indexPath) as! SingleAnswerTableViewCell

            singleAnswerCell.selectionStyle = .none
            
            
            
            let answerObject = question.questionAnswers![indexPath.row-1]
            
            var answerString = ""
            
            if (indexPath.row-1) == 0 {
                
                answerString = "a. " + answerObject.answer!
                
            } else if (indexPath.row-1) == 1 {

                answerString = "b. " + answerObject.answer!

            } else if (indexPath.row-1) == 2 {
                
                answerString = "c. " + answerObject.answer!

            }  else if (indexPath.row-1) == 3 {

                answerString = "d. " + answerObject.answer!

            }

            
            singleAnswerCell.answerLabel.text = answerString
            
            singleAnswerCell.borderLabel.layer.borderColor = UIColor.black.cgColor
            singleAnswerCell.borderLabel.layer.borderWidth = 1.5;
                        
            
            if ((question.currentAnswerIsCorrect == question.correctAnswer) && (question.currentAnswerIsCorrect == answerObject.answer!))
            {
                
                UIView.transition(with: singleAnswerCell.borderLabel!, duration: 1.5, options: .transitionFlipFromRight, animations: {
                    
                    singleAnswerCell.answerLabel.textColor = UIColor.lightGray
                    singleAnswerCell.borderLabel.backgroundColor = UIColor(red: 128/255, green: 202/255, blue: 14/255, alpha: 1.0)
                    singleAnswerCell.borderLabel.alpha = 1
                    singleAnswerCell.answerImageView.isHidden = false
                    singleAnswerCell.answerImageView.image = UIImage(named: "TickCheck")
                    
                    
                }, completion: nil)
                
            }
            else if ((answerObject.answer! == question.currentAnswerIsCorrect) && ((question.currentAnswerIsCorrect?.count)! > 0))
            {
                
                UIView.transition(with: singleAnswerCell.borderLabel!, duration: 1.5, options: .transitionFlipFromRight, animations: {
                    
                    singleAnswerCell.answerLabel.textColor = UIColor.lightGray
                    singleAnswerCell.borderLabel.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
                    singleAnswerCell.answerImageView.isHidden = false
                    singleAnswerCell.answerImageView.image = UIImage(named: "CrossCheck")
                    
                }, completion: { finished in
                    UIView.animate(withDuration: 2.0, animations: {
                        
                        singleAnswerCell.answerLabel.textColor = UIColor.lightGray
                        singleAnswerCell.answerImageView.isHidden = true
                        singleAnswerCell.borderLabel.backgroundColor = UIColor.clear
                        singleAnswerCell.borderLabel.alpha = 0.1

                    })
                })
            }
            else if (question.answerSelection!.contains(answerObject.answer!))
            {
                
                singleAnswerCell.answerLabel.textColor = UIColor.lightGray
                singleAnswerCell.answerImageView.isHidden = true
                singleAnswerCell.borderLabel.backgroundColor = UIColor.clear
                singleAnswerCell.borderLabel.alpha = 0.1
            }
            else
            {
                singleAnswerCell.answerLabel.textColor = UIColor.black
                singleAnswerCell.answerImageView.isHidden = true
                singleAnswerCell.borderLabel.backgroundColor = UIColor.clear
                singleAnswerCell.borderLabel.alpha = 1
            }
            
            
            return singleAnswerCell

        }
        
        var cell: UITableViewCell!
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.invalidateAllTimers()
        
        var question = self.questionsArray[indexPath.section]
        
        if (question.questionType == "Single") {
            
            let answerObject = question.questionAnswers![indexPath.row-1]

            print("select answer: %d",indexPath.row)
            
            if (answerObject.answer == question.correctAnswer){
                
                question.isCompleted = true
                question.currentAnswerIsCorrect = answerObject.answer
                question.answerSelection!.append(answerObject.answer!)
                
            } else {
                
                question.isCompleted = false
                question.currentAnswerIsCorrect = answerObject.answer
                question.answerSelection!.append(answerObject.answer!)
            }
            
            self.questionsArray[indexPath.section] = question
            self.questionTableView.reloadData()
            
            if ((self.completedQuestionsArray.count < self.allQuestionsArray.count) && (question.isCompleted == true)) {
                
                let answerObject = question.questionAnswers![indexPath.row-1]

                self.submitAnswer(question: question, answer: answerObject)
            }
        }
    }
    
    
    
    // MARK: - Button Action

    
    @objc func trueButtonAction(sender: UIButton) {
        
        self.invalidateAllTimers()

        var question = self.questionsArray[sender.tag]
        
        if (question.correctAnswer == "True") {
            
            question.isCompleted = true
            question.currentAnswerIsCorrect = "True"
            question.answerSelection!.append("True")
            
        } else {
            
            question.isCompleted = false
            question.currentAnswerIsCorrect = "True"
            question.answerSelection!.append("True")
        }
        
        self.questionsArray[sender.tag] = question
        self.questionTableView.reloadData()

        
        if  ((self.completedQuestionsArray.count < self.allQuestionsArray.count) && (question.isCompleted == true)) {
            
            self.submitAnswer(question: question, answer: question.questionAnswers![0])
        }
    }
    
    
    @objc func falseButtonAction(sender: UIButton) {
        
        self.invalidateAllTimers()

        var question = self.questionsArray[sender.tag]
        
        if (question.correctAnswer == "False") {
            
            question.isCompleted = true
            question.currentAnswerIsCorrect = "False"
            question.answerSelection!.append("False")
            
            
        } else {
            
            question.isCompleted = false
            question.currentAnswerIsCorrect = "False"
            question.answerSelection!.append("False")
        }
        
        self.questionsArray[sender.tag] = question
        self.questionTableView.reloadData()

        
        if ((self.completedQuestionsArray.count < self.allQuestionsArray.count) && (question.isCompleted == true)) {

            self.submitAnswer(question: question, answer: question.questionAnswers![1])
        }
    }
    
    //MARK:- Screen saver related
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleIdleDevice),
                                               name: .appIsIdleOnQuestionaire,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAppActivity),
                                               name: .appDetectedUserTouch,
                                               object: nil)
    }
    
    @objc func handleIdleDevice() {
        
        idleTimer = Timer.scheduledTimer(timeInterval: 20,
                                         target: self,
                                         selector: #selector(self.handleTimerForIdleDevice),
                                         userInfo: nil,
                                         repeats: false)
        
      countDownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                            target: self,
                                            selector: #selector(self.updateTime),
                                            userInfo: nil,
                                            repeats: true)

           self.timerView.isHidden = false


    }
    
    
    @objc func handleTimerForIdleDevice() {
        
       self.invalidateAllTimers()
        
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
        
        if let somePresentingController = self.presentedViewController {
            
            if somePresentingController == screenSaverViewController {
                
              //  somePresentingController.dismiss(animated: false, completion: nil)

                somePresentingController.dismiss(animated: false, completion: {
                    self.dismiss(animated: true, completion: nil)

                })
            
            }
        }
    }
    
    func presentScreenSaver() {
        
        self.screenSaverViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScreenSaverViewController") as! ScreensaverViewController

        self.present(screenSaverViewController, animated: true) {
            let url = URL.init(string: self.screenSaveURLString!)
            self.screenSaverViewController.screenSaverImageview?.af_setImage(withURL: url!)
        }
    }
}
