//
//  itineraryDetailsViewController.swift
//  planIt
//
//  Created by Tracy Chen on 5/3/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import MapKit
import MessageUI
import FirebaseDatabase
import FirebaseAuth

class itineraryDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var departLabel: UILabel!
    @IBOutlet weak var leavingDateLabel: UILabel!
    @IBOutlet weak var itineraryDetailsTableView: UITableView!
    
    var leavingFrom = ""
    var travelCountry = ""
    var leavingFromDate = ""
    var numberOfdays = ""
    var totalNumberPerActivity = 0
    var listOfActivities:[String] = []
    var listOfActivitiesForTermLabel:[String] = []
    var totalNumberAllActivities = 0
    var activityObjectCollection:[Activity] = []
    var leavingDate:Date?
    var travelingDate = ""
    var itineraryObjectCollection:[Itinerary] = []
    var htmlString = "<html><body>"
    var userCollection:[User] = []
    var ref:DatabaseReference?
    var activityNames = ""
    var apiHasBeenCalled = false
    var listOfBus = false
    
    @IBOutlet weak var saveButtonLabel: UIButton!
    @IBOutlet weak var shareButtonLabel: UIButton!
    @IBOutlet weak var mapButtonLabel: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        itineraryDetailsTableView.delegate = self
        itineraryDetailsTableView.dataSource = self
        
        saveButtonLabel.layer.cornerRadius = 20
        shareButtonLabel.layer.cornerRadius = 20
        mapButtonLabel.layer.cornerRadius = 20
        
        departLabel.text = "\(leavingFrom) to \(travelCountry)"
        totalNumberAllActivities = totalNumberPerActivity * listOfActivities.count
        
        
        var dateFormatter = DateFormatter.init(withFormat: "MM/dd/yyyy", locale: "")
        leavingDate = dateFormatter.date(from: leavingFromDate)
        var dateComponents = DateComponents.init()
        dateComponents.day = Int(numberOfdays)
        var travelingDate = Calendar.current.date(byAdding: dateComponents, to: leavingDate ?? Date())
        //travelingDateLabel.text = dateFormatter.string(from: travelingDate!)
        leavingDateLabel.text = "Dates: \(leavingFromDate) - \(dateFormatter.string(from: travelingDate!))"
        
        htmlString += "<b>Your Itinerary:</b><br><br><b>Leaving from:</b> \(leavingFrom)<br><b>Traveling to:</b> \(travelCountry)<p><b>Dates:</b> \(leavingFromDate) - \(dateFormatter.string(from: travelingDate!))<p>"
        
        
        let APIKey = "Bearer bdI2fQXX2e6OG22JRbJbRJrFwIe8BNdfK01E9Pb9fA7fgi8JDm2IVtdn_1MLzJLNFLpACOpVPJjAdCqsfRwG-klJCYrkzV08LUIsxxtBuRiTbG-uQqZGIsHFd6zVXHYx"
        
        let headers: HTTPHeaders = [
            "Authorization": APIKey]
        if listOfActivities.count == 0 {
            self.apiHasBeenCalled = true
            self.itineraryDetailsTableView.setEmptyMessage("Please select activities on the previous screen")
        }
            for i in listOfActivities {
                    self.apiHasBeenCalled = false
                AF.request("https://api.yelp.com/v3/businesses/search?term=\(i)&location=\(travelCountry)&limit=\(totalNumberPerActivity)&sort_by=rating", headers: headers).responseJSON
                    
                    { response in
                        print("Request: \(String(describing: response.request))") // original url request
                        print("Response: \(String(describing: response.response))") // http url response
                        print("Result: \(response.result)")

                        if let json = response.result.value {
                            print("JSON: \(json)") // serialized json response
                        }
                        
                        guard let responseJSON = response.result.value as? [String: AnyObject] else {
                            print("Error reading response")
                            return
                    }
                        self.listOfActivitiesForTermLabel.append(contentsOf: repeatElement(i, count: self.totalNumberPerActivity))
                        let activityObjectInfo = Mapper<activityBusiness>().map(JSONObject: responseJSON)
                        let listOfBusiness = activityObjectInfo?.businesses
                        var categoryType = i
                        
                        for i in listOfBusiness ?? [] {
                            let businessInfoObject = Activity(name: i.name ?? "", image_url: i.image_url ?? "", url: i.url ?? "", latitude: i.latitude ?? 0.0, longitude: i.longitude ?? 0.0, display_address: i.display_address ?? [], rating: i.rating ?? 0.0, coordinates: i.coordinates ?? [:], displayAddressExtracted: i.parseAddress() ?? "", type: categoryType ?? "")
                            self.activityObjectCollection.append(businessInfoObject)

                            self.htmlString += "<b>\(businessInfoObject.name ?? "")</b><br><b>Type: </b>\(categoryType)<br>"
                            
                            for addressItem in businessInfoObject.display_address ?? [] {
                                self.htmlString += addressItem + " "
                            }
                            
                            self.htmlString += "<br><b>Yelp rating (out of 5):</b> \(businessInfoObject.rating ?? 0.0)<br><br>"
                        }
                        
                        self.htmlString += "</body></html>"
                        if (self.activityObjectCollection.count == self.totalNumberAllActivities) {
                            self.itineraryDetailsTableView.reloadData()
                        } else if self.activityObjectCollection.count == 0 {
                            self.itineraryDetailsTableView.setEmptyMessage("Location has no available activities. Please try a different city.")
                        }
                }
            }
        }


    @IBAction func onSaveTap(_ sender: Any) {
        if leavingFrom == "" || travelCountry == "" || leavingDate == nil || listOfActivities.count == 0 {
            let alertController = UIAlertController(title: "Alert", message: "Please go back and enter where you are leaving from, traveling to, departing date and select your activities", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        } else {
            var itineraryObject:Itinerary = Itinerary.init(leavingFrom: leavingFrom, travellingTo: travelCountry, leavingDate: leavingDate ?? Date(), travellingDates: leavingDateLabel.text ?? "", activitiesArray: activityObjectCollection, numberOfDays: numberOfdays)
            itineraryObjectCollection.append(itineraryObject)
            print(itineraryObjectCollection)
            var userItinerary = User.init(userID: "", username: "", itineraryArray: itineraryObjectCollection)
            //print(userItinerary.itineraryArray)
            performSegue(withIdentifier: "itineraryDetailstoItineraryListSegue", sender: self)
            
            
            let uid = (Auth.auth().currentUser?.uid ?? nil)!
            let thisUserItineraries = self.ref!.child("users").child(uid).child("Itineraries")
            let holder = thisUserItineraries.childByAutoId().child("Itinerary")
            
            let dict: [String : Any] = ["Travel Country": itineraryObject.travellingTo, "Leaving From": itineraryObject.leavingFrom, "Traveling Dates": itineraryObject.travellingDates, "Number of Days": numberOfdays]
            
            holder.setValue(dict)
            
            let activityHolder = holder.child("Activities")
            
            for activity in activityObjectCollection {
                let activityDict: [String : Any] = ["name": activity.name, "image_url": activity.image_url, "latitude": activity.latitude, "longitude": activity.longitude, "coordinates": activity.coordinates, "rating": activity.rating, "url": activity.url, "Display address": activity.displayAddressExtracted, "type": activity.type]
                
                activityHolder.childByAutoId().setValue(activityDict)
            }
        }
        
        /* THIS WORKS
        var itineraryObject:Itinerary = Itinerary.init(leavingFrom: leavingFrom, travellingTo: travelCountry, leavingDate: leavingDate ?? Date(), travellingDates: leavingDateLabel.text ?? "", activitiesArray: activityObjectCollection, numberOfDays: numberOfdays)
        itineraryObjectCollection.append(itineraryObject)
        print(itineraryObjectCollection)
        var userItinerary = User.init(userID: "", username: "", itineraryArray: itineraryObjectCollection)
        //print(userItinerary.itineraryArray)
        performSegue(withIdentifier: "itineraryDetailstoItineraryListSegue", sender: self)
        
        
        let uid = (Auth.auth().currentUser?.uid ?? nil)!
        let thisUserItineraries = self.ref!.child("users").child(uid).child("Itineraries")
        let holder = thisUserItineraries.childByAutoId().child("Itinerary")
        
        let dict: [String : Any] = ["Travel Country": itineraryObject.travellingTo, "Leaving From": itineraryObject.leavingFrom, "Traveling Dates": itineraryObject.travellingDates, "Number of Days": numberOfdays]
        
        holder.setValue(dict)
        
        let activityHolder = holder.child("Activities")
        
        for activity in activityObjectCollection {
            let activityDict: [String : Any] = ["name": activity.name, "image_url": activity.image_url, "latitude": activity.latitude, "longitude": activity.longitude, "coordinates": activity.coordinates, "rating": activity.rating, "url": activity.url, "Display address": activity.displayAddressExtracted, "type": activity.type]
            
            activityHolder.childByAutoId().setValue(activityDict)
        }
 */

    }
    
    
    @IBAction func onShareTap(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    
    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        if activityObjectCollection != nil {
           return activityObjectCollection.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let urlString = self.activityObjectCollection[indexPath.row].url!
        if let url = URL(string: urlString)
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! itineraryDetailsTableViewCell
            cell.activityNameTableViewCell.text = "\(activityObjectCollection[indexPath.row].name ?? "")"
        cell.addressTableViewCell.text = "Address: \(activityObjectCollection[indexPath.row].displayAddressExtracted)"
            cell.typeOfActivityTableViewCell.text = "\(listOfActivitiesForTermLabel[indexPath.row])"
        cell.yelpRatingTableViewCell.text = "Yelp rating (out of 5): \(activityObjectCollection[indexPath.row].rating ?? 0.0)"
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "itineraryDetailstoMapVC"){
            let vc = segue.destination as! itineraryMapViewController
            vc.businessCoordinates = activityObjectCollection
            print("THIS IS FROM SEGUE: \(activityObjectCollection)")
       } else if (segue.identifier == "itineraryDetailstoItineraryListSegue") {
            let itinerariesTripsVC = segue.destination as! itineraryTripsViewController
            itinerariesTripsVC.travelCountry = travelCountry
            itinerariesTripsVC.leavingFromDate = leavingFromDate
            itinerariesTripsVC.travelingDate = leavingDateLabel.text ?? ""
       }
    }
 
    @IBAction func onMapTapped(_ sender: Any) {
        performSegue(withIdentifier: "itineraryDetailstoMapVC", sender: self)
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 25)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
