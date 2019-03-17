//
//  SingleAnswerTableViewCell.swift
//  QuestionAnswer
//
//  Created by Nikhil Wagh on 3/16/19.
//  Copyright © 2019 Nikhil Wagh. All rights reserved.
//

import UIKit

class SingleAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var answerImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
