//
//  WinnerSelectionTableViewCell.swift
//  Kiosk
//
//  Created by Deepak Sharma on 10.09.18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import UIKit

protocol WinnerTableViewCellDelegate:class {
    func showEmail(email: String)
    func redraw(id: Int, cell: WinnerTableViewCell)
    func contactWinner(id: Int)

}

class WinnerTableViewCell: UITableViewCell {

    @IBOutlet weak var winnerName: UILabel!
    
    @IBOutlet weak var contactWinnerButton: UIButton!
    weak var deleagte: WinnerTableViewCellDelegate?
    private var winner: Winner!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(winner: Winner, shouldShownContactWinnerButton: Bool) {
        self.winner = winner
        contactWinnerButton.isHidden = !shouldShownContactWinnerButton
        winnerName.text = winner.name
    }
    
    
    @IBAction func showEmail(_ sender: Any) {
        deleagte?.showEmail(email: winner.email)
    }
    
    @IBAction func redraw(_ sender: Any) {
        deleagte?.redraw(id: winner.id, cell:  self)
    }
    
    @IBAction func contactWinner(_ sender: Any) {
        deleagte?.contactWinner(id: winner.id)
    }
    
    
    
}
