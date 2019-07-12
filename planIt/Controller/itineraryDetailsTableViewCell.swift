//
//  itineraryDetailsTableViewCell.swift
//  planIt
//
//  Created by Tracy Chen on 5/15/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit

class itineraryDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var activityNameTableViewCell: UILabel!
    @IBOutlet weak var addressTableViewCell: UILabel!
    @IBOutlet weak var urlTableViewCell: UILabel!
    @IBOutlet weak var typeOfActivityTableViewCell: UILabel!
    @IBOutlet weak var yelpRatingTableViewCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
