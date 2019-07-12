//
//  planYourTripViewController.swift
//  planIt
//
//  Created by Tracy Chen on 5/3/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit

class planYourTripViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var leavingFrom: UITextField!
    @IBOutlet weak var leavingFromDate: UITextField!
    @IBOutlet weak var travelingTo: UITextField!
    @IBOutlet weak var numberOfDays: UITextField!
    @IBOutlet weak var chooseActivitiesLabel: UIButton!
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        chooseActivitiesLabel.layer.cornerRadius = 20
        
        leavingFrom.delegate = self
        leavingFromDate.delegate = self
        travelingTo.delegate = self
        numberOfDays.delegate = self
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(planYourTripViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(planYourTripViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        leavingFromDate.inputView = datePicker
        createToolbar()
        
        leavingFrom.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        travelingTo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        //.editingDidChange - prevents users from inputting any spaces in input
        
        
}

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let text = textField.text ?? ""
        
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        textField.text = trimmedText
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        leavingFromDate.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(planYourTripViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        leavingFromDate.inputAccessoryView = toolBar
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "planTripToActivitiesSegue"){
                let activitiesVC = segue.destination as! activitiesViewController
                activitiesVC.numberOfdays = numberOfDays.text ?? ""
                activitiesVC.travelCountry = travelingTo.text ?? ""
                activitiesVC.leavingFrom = leavingFrom.text ?? ""
                activitiesVC.leavingFromDate = leavingFromDate.text ?? ""
            }
        }
    
    
    /*
        func toDate(format: String) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.locale = Locale.current
            return dateFormatter.date(from: leavingFromDate.text ?? "")
        }
    
    
        func toString(format: String) -> String? {
            let df = DateFormatter()
            df.dateFormat = format
            return df.string(from: self)
        }

        
        func add(component: Calendar.Component, value: Int) -> Date? {
            return Calendar.current.date(byAdding: Calendar.Component, value: numberOfDays.text!, to: leavingFromDate.text!)
        }
    */
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case leavingFrom:
            leavingFromDate.becomeFirstResponder()
        case leavingFromDate:
            travelingTo.becomeFirstResponder()
        case travelingTo:
            numberOfDays.becomeFirstResponder()
        default:
            numberOfDays.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func onChooseActivitiesTap(_ sender: Any) {
        performSegue(withIdentifier: "planTripToActivitiesSegue", sender: self)
    }
    

//    @IBAction func onBackTap(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

