//
//  itineraryTripsCollectionViewCell.swift
//  planIt
//
//  Created by Tracy Chen on 6/2/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit

protocol cellDelegate: class {
    func delete(cell: itineraryTripsCollectionViewCell)
}

class itineraryTripsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var destinationLabelonItineraryTrips: UILabel!
    @IBOutlet weak var datesLabelonItineraryTrips: UILabel!
    @IBOutlet weak var deleteLabel: UIButton!
    
    weak var delegate: cellDelegate?
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        delegate?.delete(cell: self)
    }
    
}
