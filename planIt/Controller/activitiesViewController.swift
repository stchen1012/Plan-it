//
//  suggestionsViewController.swift
//  planIt
//
//  Created by Tracy Chen on 5/3/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit
import Alamofire

class activitiesViewController: UIViewController {

    var travelCountry = ""
    var numberOfdays = ""
    var leavingFrom = ""
    var leavingFromDate = ""
    var totalNumberPerActivity = 0
    var listOfActivities:[String] = []
    @IBOutlet weak var generateLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateLabel.layer.cornerRadius = 20
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.darkGray.cgColor, UIColor.white.cgColor]
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    

    @IBAction func buttonTapActivity(_ sender: UIButton) {
        if let button = sender as? UIButton {
            if button.isSelected {
                //set deselected
                button.isSelected = false
                let itemToRemove = button.titleLabel?.text
                if let index = listOfActivities.firstIndex(of: itemToRemove ?? "") {
                    listOfActivities.remove(at: index)}
            } else {
                //set selected
                if listOfActivities.count < 4 {
                    button.tintColor = UIColor.white
                    button.isSelected = true
                    listOfActivities.append(button.titleLabel?.text ?? "")
                    print(listOfActivities)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "activitiesToItineraryDetailsSegue"){
            let itinerariesVC = segue.destination as! itineraryDetailsViewController
            itinerariesVC.numberOfdays = numberOfdays
            itinerariesVC.travelCountry = travelCountry
            itinerariesVC.leavingFrom = leavingFrom
            itinerariesVC.leavingFromDate = leavingFromDate
            itinerariesVC.totalNumberPerActivity = totalNumberPerActivity
            itinerariesVC.listOfActivities = listOfActivities
        }
    }

    
    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onGenerateTap(_ sender: Any) {
        switch listOfActivities.count {
        case 1:
            totalNumberPerActivity = (Int(numberOfdays) ?? 2) * 5
            print("case 1")
            print(numberOfdays)
        case 2:
            totalNumberPerActivity = (Int(numberOfdays) ?? 2) * 4
            print("case 2")
            print(numberOfdays)
        case 3:
            totalNumberPerActivity = (Int(numberOfdays) ?? 2) * 4
            print("case 3")
            print(numberOfdays)
        case 4:
            totalNumberPerActivity = (Int(numberOfdays) ?? 2) * 3
            print("case 4")
            print(numberOfdays)
        default:
            totalNumberPerActivity = (Int(numberOfdays) ?? 1) * 3
            print("default")
            print(numberOfdays)
        }
        
        performSegue(withIdentifier: "activitiesToItineraryDetailsSegue", sender: self)
        
    }
}


