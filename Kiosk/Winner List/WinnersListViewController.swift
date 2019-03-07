//
//  WinnersListViewController.swift
//  Kiosk
//
//  Created by Deepak Sharma on 10.09.18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import UIKit

struct Winner: Equatable {
    var id: Int
    var name: String
    var email: String
}

class WinnersListViewController: UIViewController {
    
    var winnersList = [Winner]()
    var startDate: Date!
    var endDate: Date!
    var count: Int = 1
    private let cellHeight = 77
    private var shouldShownContactWinner = false
    
    @IBOutlet weak var winnersTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var winnersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        winnersTableViewHeightConstraint.constant = CGFloat(count * cellHeight)
        
        if let text = ScreenSaver.shouldShownContactWinner(), !text.isEmpty {
            shouldShownContactWinner = true
        } else {
            shouldShownContactWinner = false
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    class func initWithStoryboard() -> WinnersListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: WinnersListViewController.self)) as! WinnersListViewController
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
    @IBAction func sendResults(_ sender: Any) {
        let masterPasswordAlertController = UIAlertController(title: "Milwaukee", message: "Please enter email.", preferredStyle: .alert)
        
        masterPasswordAlertController.addTextField { (textField) in
            textField.placeholder = "email@domain.com"
            textField.isSecureTextEntry = false
            textField.borderStyle = .roundedRect
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] submitAction in
            let passwordField = masterPasswordAlertController.textFields![0]
            
            let enteredEmail = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let enteredEmail = enteredEmail, enteredEmail.isValidEmail() {
                KioskNetworkManager.shared.sendResults(ids: self?.winnersList.map({$0.id}), email: passwordField.text, completion:  {[weak self] (sucess) in
                    
                    let message = sucess ? "Email sent successfully." : "Network error. Please contact support."
                    let alert = UIAlertController(title: "Milwaukee", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                })
            } else {
                let alert = UIAlertController(title: "Milwaukee", message: "Please Enter valid email", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { cancelAction in
            
        }
        
        masterPasswordAlertController.addAction(submitAction)
        masterPasswordAlertController.addAction(cancelAction)
        
        self.present(masterPasswordAlertController, animated: true)
        
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension WinnersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return winnersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let winnerTableViewCell =  tableView.dequeueReusableCell(withIdentifier: String.init(describing: WinnerTableViewCell.self), for: indexPath) as!  WinnerTableViewCell
        winnerTableViewCell.configure(winner: winnersList[indexPath.row], shouldShownContactWinnerButton: shouldShownContactWinner)
        winnerTableViewCell.deleagte = self
        return winnerTableViewCell
    }
    
    
}

extension WinnersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    
}


extension WinnersListViewController: WinnerTableViewCellDelegate {
    
    func showEmail(email: String) {
        let alert = UIAlertController(title: "Email", message: email, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func redraw(id: Int, cell: WinnerTableViewCell) {
        
        KioskNetworkManager
            .shared.redrawWinner(id: id, from: startDate, to: endDate, totalWinner: count, completion:  {[weak self] (sucess, winnerDictionary) in
                
                self?.messageAlert(isSuccess: sucess)
                
                guard let strongSelf = self else {
                    return
                }
                
                if let newWinnerDictionary = winnerDictionary {
                    let newWinner = Winner.init(id: newWinnerDictionary["winnerID"] as! Int, name: (newWinnerDictionary["firstName"] as! String) + " " + (newWinnerDictionary["lastName"] as! String) , email: newWinnerDictionary["email"] as! String)

                    if let indexPathToReplace = strongSelf.winnersTableView.indexPath(for: cell) {
                        strongSelf.winnersList.remove(at: indexPathToReplace.row)
                        strongSelf.winnersList.insert(newWinner, at: indexPathToReplace.row)
                        strongSelf.winnersTableView.reloadData()
                    }
                }
            })
        
    }
    
    func contactWinner(id: Int) {
        KioskNetworkManager.shared.contactWinner(id: id, completion:  {[weak self] (sucess) in
            
            let message = sucess ? "Email sent successfully." : "Network error. Please contact support."
            let alert = UIAlertController(title: "Milwaukee", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self?.present(alert, animated: true)
            
            
        })
    }
    
    
    private func messageAlert(isSuccess: Bool) {
        
        let message = isSuccess ? "Success" : "Error"
        
        let alert = UIAlertController(title: "Milwaukee", message: message, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
