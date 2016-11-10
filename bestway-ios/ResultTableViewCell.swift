//
//  ResultTableViewCell.swift
//  bestway-ios
//
//  Created by Damien Bannerot on 10/11/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var timeLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
