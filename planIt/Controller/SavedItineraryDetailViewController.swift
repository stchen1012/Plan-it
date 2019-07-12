//
//  SavedItineraryDetailViewController.swift
//  planIt
//
//  Created by Tracy Chen on 6/15/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit
import MessageUI
import MapKit


class savedItineraryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    var itineraryFBSegueHolder:[Itinerary] = []//THIS STORES ALL USER ITINERARIES
    var individualItineraryFBSegueHolder:[Itinerary] = []// STORES SELECTED FROM CV ITINERARY INFO
    
    @IBOutlet weak var travelToandLeavingFromLabel: UILabel!
    @IBOutlet weak var travelDatesLabel: UILabel!
    @IBOutlet weak var savedItineraryDetailsTableView: UITableView!
    @IBOutlet weak var mapButtonLabel: UIButton!
    @IBOutlet weak var shareButtonLabel: UIButton!
    
    
    
    var activitiesForEmailArray:[Activity] = []
    var htmlString = "<html><body>"
    
    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMapTap(_ sender: Any) {
        performSegue(withIdentifier: "savedItineraryDetailstoMapVCSegue", sender: self)
    }

    @IBAction func onShareTap(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        savedItineraryDetailsTableView.delegate = self
        savedItineraryDetailsTableView.dataSource = self
        
        mapButtonLabel.layer.cornerRadius = 20
        shareButtonLabel.layer.cornerRadius = 20
        
        travelToandLeavingFromLabel.text = "\(individualItineraryFBSegueHolder[0].leavingFrom ?? "") - \(individualItineraryFBSegueHolder[0].travellingTo ?? "")"
        
        travelDatesLabel.text = individualItineraryFBSegueHolder[0].travellingDates
        
        savedItineraryDetailsTableView.reloadData()
        
        htmlString += "<b>Your Itinerary:</b><br><br><b>Leaving from:</b> \(individualItineraryFBSegueHolder[0].leavingFrom ?? "")<br><b>Traveling to:</b> \(individualItineraryFBSegueHolder[0].travellingTo ?? "")<p><b>Dates:</b> \(individualItineraryFBSegueHolder[0].travellingDates ?? "")<p>"
        
        activitiesForEmailArray = individualItineraryFBSegueHolder[0].activitiesArray
        
        for i in activitiesForEmailArray {
            self.htmlString += "<b>\(i.name ?? "")</b><br><b>Type: </b>\(i.type ?? "")<br>"
            self.htmlString += "<b>Address:</b> \(i.displayAddressExtracted)"
            self.htmlString += "<br><b>Yelp rating (out of 5):</b> \(i.rating ?? 0.0)<br><br>"
            self.htmlString += "</body></html>"
        }

    }


    
    // this function adds email functionality
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("Your Plan(it) Itinerary")
        mailComposerVC.setMessageBody(htmlString, isHTML: true)
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Error", message: "Could not send", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return individualItineraryFBSegueHolder[0].activitiesArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let urlString = individualItineraryFBSegueHolder[0].activitiesArray[indexPath.row].url!
        if let url = URL(string: urlString)
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! savedItineraryDetailsTableViewCell
        cell.savedActivityName.text = "\(individualItineraryFBSegueHolder[0].activitiesArray[indexPath.row].name ?? "")"
        cell.savedAddressLabel.text = "Address: \(individualItineraryFBSegueHolder[0].activitiesArray[indexPath.item].displayAddressExtracted ?? "")"
        cell.savedYelpRatingLabel.text = "Yelp rating (out of 5): \(individualItineraryFBSegueHolder[0].activitiesArray[indexPath.row].rating ?? 0.0)"
        cell.savedTypeLabel.text  = "\(individualItineraryFBSegueHolder[0].activitiesArray[indexPath.item].type ?? "")"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "savedItineraryDetailstoMapVCSegue"){
            let vc = segue.destination as! savedItineraryMapViewController
            vc.individualItineraryInfoArray = individualItineraryFBSegueHolder
        }
    }
}
