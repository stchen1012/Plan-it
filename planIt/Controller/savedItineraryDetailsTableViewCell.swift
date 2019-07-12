//
//  savedItineraryDetailsTableViewCell.swift
//  planIt
//
//  Created by Tracy Chen on 6/29/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit

class savedItineraryDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var savedActivityName: UILabel!
    @IBOutlet weak var savedAddressLabel: UILabel!
    @IBOutlet weak var savedYelpRatingLabel: UILabel!
    @IBOutlet weak var savedTypeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
