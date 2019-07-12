//
//  itineraryTripsViewController.swift
//  planIt
//
//  Created by Tracy Chen on 5/3/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class itineraryTripsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var itineraryTripsCollectionView: UICollectionView!
    var travelCountry = ""
    var leavingFromDate = ""
    var travelingDate = ""
    var itineriesData: [Itinerary] = []
    var holder:[Any] = []
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var activityArrayPlaceHolder: [String] = []
    var uuidsInActivities: [String] = []
    var itineraryFBActivitiesObjectArray: [Activity] = []
    var itineraryFBObjectArray: [Itinerary] = []
    var currentDateTimeString = ""
    var isEditingCollectionView = false
    @IBOutlet weak var editButtonLabel: UIButton!
    @IBAction func onEditTap(_ sender: Any) {
        if (isEditingCollectionView) { // isEditingCollectionView == true
            editButtonLabel.setTitle("EDIT", for: .normal)
            isEditingCollectionView = false
        }
        else{
            editButtonLabel.setTitle("DONE", for: .normal)
            isEditingCollectionView = true
        }
        itineraryTripsCollectionView.reloadData()
    }
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itineraryTripsCollectionView.delegate = self
        itineraryTripsCollectionView.dataSource = self
        
        var currentDateTime = Date()
        // initialize the date formatter and set the style
        let formatter = DateFormatter.init(withFormat: "MM/dd/yyyy", locale: "")
//        formatter.timeStyle = .none
//        formatter.dateStyle = .long
        
        // get the date time String from the date object
        currentDateTimeString = formatter.string(from: currentDateTime)
        
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref?.child("users").child(userID!).child("Itineraries").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    var orderID = child.key as! String
                    //print(orderID)
                    self.activityArrayPlaceHolder.append(orderID)
                }}
            
            for uuids in self.activityArrayPlaceHolder{
                self.ref?.child("users").child(userID!).child("Itineraries").child(uuids).child("Itinerary").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    
                    var activitiesDict: NSDictionary = value!["Activities"]! as! NSDictionary

                    for (key,value) in activitiesDict{
                        let valueDict = value as? NSDictionary// swift makes you re-declare nsdict every time
                        var itineraryFBActivitiesObject = Activity(name: valueDict?["name"] as? String ?? "", image_url: valueDict?["image_url"] as? String ?? "", url: valueDict?["url"] as? String ?? "", latitude: valueDict?["latitude"] as? Double ?? 0.0, longitude: valueDict?["longitude"] as? Double ?? 0.0, display_address: valueDict?["Display address extracted"] as? [String] ?? [], rating: valueDict?["rating"] as? Float ?? 0.0, coordinates: valueDict?["coordinates"] as? [String: Double] ?? [:], displayAddressExtracted: valueDict?["Display address"] as? String ?? "", type: valueDict?["type"] as? String ?? "")
                        self.itineraryFBActivitiesObjectArray.append(itineraryFBActivitiesObject)
                    }
                    var itineraryFBObject = Itinerary(leavingFrom: value?["Leaving From"] as? String ?? "", travellingTo: value?["Travel Country"] as? String ?? "", leavingDate: Date(), travellingDates: value?["Traveling Dates"] as? String ?? "", activitiesArray: self.itineraryFBActivitiesObjectArray, numberOfDays: value?["Number of Days"] as? String ?? "")
                    self.itineraryFBActivitiesObjectArray = []
                    self.itineraryFBObjectArray.append(itineraryFBObject)
                    self.itineraryTripsCollectionView.reloadData()

                }
            )}
        }
    )}
        /*
        //KEEP THIS CODE - IT WORKS
        let userID = Auth.auth().currentUser?.uid
        ref?.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let fullname = value?["fullname"] as? String ?? ""
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let snapshotDictionary = snap.value! as? [String: Any] // returns all Itineraries
                let itinerarySnap = snap.childSnapshot(forPath: "Itinerary") // doesn't work
                print(itinerarySnap)
 
*/
        
        
        // Set the firebase reference
        //ref = Database.database().reference()
        /*
        let ref = Database.database().reference(withPath: "user")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            print(snapshot) // Its print all values including Snap (User)
            
            print(snapshot.value!)
            
            let username = snapshot.childSnapshot(forPath: "fullname").value
            print(username!)
            
        })
        
        // Retrieve posts
        
//        ref?.child("Itineraries").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot,
//                    let itinerary = Itinerary(map: snapshot) {
//                self.itinerariesData.append(itinerary)
//            }
//
//            self.itineraryTripsCollectionView.reloadData()
//        }
//    }
        /*
        // Retrieve posts
        databaseHandle = ref?.child("Itineraries").observe(.childAdded, with: { (snapshot) in
            
            //code to execute when child is added under "Itineraries"
            //take value from snapshot & add to itinerariesData arry
            
            let post = snapshot.value as? String
            
            if let actualPost = post {
            self.itinerariesData.append(actualPost)
                
                self.itineraryTripsCollectionView.reloadData()
            }
        })
 */
 */
    
    @IBAction func plusButtonTap(_ sender: UIButton) {
        performSegue(withIdentifier: "itineraryTripstoHomeSegue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itineraryFBObjectArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! itineraryTripsCollectionViewCell
        cell.destinationLabelonItineraryTrips.text = itineraryFBObjectArray[indexPath.item].travellingTo
        cell.datesLabelonItineraryTrips.text = itineraryFBObjectArray[indexPath.item].travellingDates
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.delegate = self
        if (isEditingCollectionView) {
            cell.deleteLabel.isHidden = false
        } else {
            cell.deleteLabel.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "itineraryTripsVCtoSavedItineraryDetailsSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "itineraryTripsVCtoSavedItineraryDetailsSegue" {
            let selectedIndexPath = sender as? NSIndexPath
            let savedItineraryVC = segue.destination as! savedItineraryDetailViewController
            savedItineraryVC.itineraryFBSegueHolder = itineraryFBObjectArray
            savedItineraryVC.individualItineraryFBSegueHolder = [itineraryFBObjectArray[(selectedIndexPath?.item)!]]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print(indexPath.item)
        return true
    }
}

extension itineraryTripsViewController : cellDelegate {
    func delete(cell: itineraryTripsCollectionViewCell) {
        if let indexPath = itineraryTripsCollectionView?.indexPath(for: cell) {
            // 1. delete the item from the data source
            ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
        ref?.child("users").child(userID!).child("Itineraries").child(self.activityArrayPlaceHolder[indexPath.item]).removeValue()
            itineraryFBObjectArray.remove(at: indexPath.item)

            // 2. delete cell at that index path from the collection view
            itineraryTripsCollectionView?.deleteItems(at: [indexPath])
            itineraryTripsCollectionView.reloadData()
        }
    }
}

