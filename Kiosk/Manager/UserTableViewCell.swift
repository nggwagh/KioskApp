//
//  UserTableViewCell.swift
//  Kiosk
//
//  Created by Mohini Mehetre on 30/03/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var checkUncheckImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
