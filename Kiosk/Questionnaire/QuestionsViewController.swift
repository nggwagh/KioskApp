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

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - View Lifecycle

    @IBOutlet weak var questionTableView: UITableView!
    
    var allQuestionsArray = [Question]()
    var questionsArray = [Question]()
    var completedQuestionsArray = [Question]()
    var randomIndexArray = [Int]()

    var screenSaverPlayer = AVPlayerViewController()
    var idleTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.isHidden = true
        
        allQuestionsArray.append(Question.init(questionTitle: "When you put a Milwaukee fuel tool through a heavy application, the Redlink+ intelligence can demand more power from the battery to help complete the application.", questionType: "Radio", questionAnswers: ["True", "False"], answerSelection: [], correctAnswer: "True", isVisible: true, isCompleted: false, currentAnswerIsCorrect: ""))

        allQuestionsArray.append(Question.init(questionTitle: "When you put a Milwaukee fuel tool", questionType: "Radio", questionAnswers: ["True", "False"], answerSelection: [], correctAnswer: "False", isVisible: false, isCompleted: false, currentAnswerIsCorrect: ""))

         allQuestionsArray.append(Question.init(questionTitle: "the Redlink+ intelligence can demand more power from the battery to help complete the application.", questionType: "Radio", questionAnswers: ["True", "False"], answerSelection: [], correctAnswer: "False", isVisible: false, isCompleted: false, currentAnswerIsCorrect: ""))
        
      //   allQuestionsArray.append(Question.init(questionTitle: "the battery to help complete the application.", questionType: "Radio", questionAnswers: ["True", "False"], answerSelection: [], correctAnswer: "True", isVisible: false, isCompleted: false, currentAnswerIsCorrect: ""))
        
        allQuestionsArray.append(Question.init(questionTitle: "What is Milwaukee fuel?", questionType: "Single", questionAnswers: ["Combination of Red-lithium Batteries, Redlink+ intelligence, and Powerstate Brushless Motors", "Higher voltage Milwaukee tools", "Gas powered Milwaukee tools", "Milwaukee’s brushless tools"], answerSelection: [], correctAnswer: "Milwaukee’s brushless tools", isVisible: false, isCompleted: false, currentAnswerIsCorrect: ""))
        
        
        self.getRandomQuestionFromAllQuestions()
        self.addObservers()
    }

    // MARK: - Private Methods
    
    func getRandomQuestionFromAllQuestions() {
        
        if (self.completedQuestionsArray.count == 4){
            
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
            
            singleAnswerCell.answerLabel.text = (question.questionAnswers![indexPath.row-1] as! String)
            
            singleAnswerCell.borderLabel.layer.borderColor = UIColor.black.cgColor
            singleAnswerCell.borderLabel.layer.borderWidth = 1.5;
                        
            
            if ((question.currentAnswerIsCorrect == question.correctAnswer) && (question.currentAnswerIsCorrect == singleAnswerCell.answerLabel.text)) {
                
                UIView.transition(with: singleAnswerCell.borderLabel!, duration: 1.5, options: .transitionFlipFromRight, animations: {
                    
                    singleAnswerCell.answerLabel.textColor = UIColor.lightGray
                    singleAnswerCell.borderLabel.backgroundColor = UIColor(red: 128/255, green: 202/255, blue: 14/255, alpha: 1.0)
                    singleAnswerCell.borderLabel.alpha = 1
                    singleAnswerCell.answerImageView.isHidden = false
                    singleAnswerCell.answerImageView.image = UIImage(named: "TickCheck")
                    
                    
                }, completion: nil)
                
            }
            else if ((singleAnswerCell.answerLabel.text == question.currentAnswerIsCorrect) && ((question.currentAnswerIsCorrect?.count)! > 0))
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
            else if (question.answerSelection!.contains(singleAnswerCell.answerLabel.text!))
            {
                
                singleAnswerCell.answerLabel.textColor = UIColor.lightGray
                singleAnswerCell.answerImageView.isHidden = true
                singleAnswerCell.borderLabel.backgroundColor = UIColor.clear
                singleAnswerCell.borderLabel.alpha = 0.1
            }
            
            
            return singleAnswerCell

        }
        
        var cell: UITableViewCell!
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var question = self.questionsArray[indexPath.section]
        
        if (question.questionType == "Single") {
            
            print("select answer: %d",indexPath.row)
            
            if ((question.questionAnswers![indexPath.row-1] as! String) == question.correctAnswer){
                
                question.isCompleted = true
                question.isVisible = true
                question.currentAnswerIsCorrect = (question.questionAnswers![indexPath.row-1] as! String)
                question.answerSelection!.append((question.questionAnswers![indexPath.row-1] as! String))
                
            } else {
                
                question.isCompleted = false
                question.isVisible = true
                question.currentAnswerIsCorrect = (question.questionAnswers![indexPath.row-1] as! String)
                question.answerSelection!.append((question.questionAnswers![indexPath.row-1] as! String))
            }
            
            self.questionsArray[indexPath.section] = question
            self.questionTableView.reloadData()
            
            if ((self.completedQuestionsArray.count < 4) && (question.isCompleted == true)) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    
                    self.completedQuestionsArray.append(question)
                    self.questionsArray.removeAll()
                    self.questionTableView.reloadData()
                    
                    self.getRandomQuestionFromAllQuestions()
                })
            }
        }
        
        
    }
    
    
    // MARK: - Button Action

    
    @objc func trueButtonAction(sender: UIButton) {
        
        var question = self.questionsArray[sender.tag]

        if (question.correctAnswer == "True") {
            
            question.isCompleted = true
            question.isVisible = true
            question.currentAnswerIsCorrect = "True"
            question.answerSelection!.append("True")
            
        } else {
            
            question.isCompleted = false
            question.isVisible = true
            question.currentAnswerIsCorrect = "True"
            question.answerSelection!.append("True")
        }
        
        self.questionsArray[sender.tag] = question
        self.questionTableView.reloadData()

        
        if  ((self.completedQuestionsArray.count < 4) && (question.isCompleted == true)) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                
                self.completedQuestionsArray.append(question)
                self.questionsArray.removeAll()
                self.questionTableView.reloadData()

                self.getRandomQuestionFromAllQuestions()
            })
        }
    }
    

    
    @objc func falseButtonAction(sender: UIButton) {
        
        var question = self.questionsArray[sender.tag]
        
        if (question.correctAnswer == "False") {
            
            question.isCompleted = true
            question.isVisible = true
            question.currentAnswerIsCorrect = "False"
            question.answerSelection!.append("False")
            
            
        } else {
            
            question.isCompleted = false
            question.isVisible = true
            question.currentAnswerIsCorrect = "False"
            question.answerSelection!.append("False")
        }
        
        self.questionsArray[sender.tag] = question
        self.questionTableView.reloadData()

        
        if ((self.completedQuestionsArray.count < 4) && (question.isCompleted == true)) {

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                
                self.completedQuestionsArray.append(question)
                self.questionsArray.removeAll()
                self.questionTableView.reloadData()
                
                self.getRandomQuestionFromAllQuestions()
            })
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.screenSaverPlayer.player?.currentItem)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newScreenSaverUpdated),
                                               name: .updatedScreenSaver,
                                               object: nil)
    }
    
    @objc func handleIdleDevice() {
        
        idleTimer = Timer.scheduledTimer(timeInterval: 20,
                                         target: self,
                                         selector: #selector(self.handleTimerForIdleDevice),
                                         userInfo: nil,
                                         repeats: false)
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    @objc func handleTimerForIdleDevice() {
        
        idleTimer!.invalidate()
        MBProgressHUD.hide(for: self.view, animated: true)
        
        SyncEngine.shared.startEngine()
        
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
        
        if let _ = self.presentedViewController as? AVPlayerViewController {
            _ = configureScreenSaverPlayer()
        }
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
        
//        guard let url = ScreenSaver.getUrlForScreensaver() else { return false }

        let url = URL.init(string: "https://www.youtube.com/watch?v=CD8PP8SHMPM")
        screenSaverPlayer.player?.pause()
        screenSaverPlayer.player = AVPlayer(url: url!)
        screenSaverPlayer.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        screenSaverPlayer.entersFullScreenWhenPlaybackBegins = true
        screenSaverPlayer.showsPlaybackControls = false
        screenSaverPlayer.player?.play()
        return true
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.screenSaverPlayer.player?.seek(to: kCMTimeZero)
        self.screenSaverPlayer.player?.play()
    }
}

