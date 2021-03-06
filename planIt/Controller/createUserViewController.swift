//
//  createViewController.swift
//  planIt
//
//  Created by Tracy Chen on 5/3/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class createUserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var createUserNameTextField: UITextField!
    @IBOutlet weak var createUserEmailTextField: UITextField!
    @IBOutlet weak var createUserPasswordTextField: UITextField!
    @IBOutlet weak var termsLabel: UILabel!
    var stateOfCheckBox = false
    
    @IBAction func onCheckBoxTap(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            stateOfCheckBox = false
        } else {
            sender.isSelected = true
            stateOfCheckBox = true
        }
    }
    @IBOutlet weak var createButtonLabel: UIButton!
    @IBOutlet weak var loginButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        createUserNameTextField.delegate = self
        createUserEmailTextField.delegate = self
        createUserPasswordTextField.delegate = self
        createButtonLabel.layer.cornerRadius = 20
        loginButtonLabel.layer.cornerRadius = 20
        termsLabel.layer.cornerRadius = 20
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createUserViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemTeal.cgColor, UIColor.white.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
        //SET VALUES IN FIREBASE
        //ref.child("itineraries").child("0").setValue(["travellingTo": "Japan"])
        
        /*
         //BELOW FOR READING DATA IN FIREBASE
        ref.child("users").child("0").observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        let value = snapshot.value as? NSDictionary
        let username = value?["username"] as? String ?? ""
        
        // ...
        }) { (error) in
            print(error.localizedDescription)
            }
        
         //let indexObjectInfo = Mapper<StockInfo>().map(JSONObject: responseJSON)
    }
 */
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case createUserNameTextField:
            createUserEmailTextField.becomeFirstResponder()
        case createUserEmailTextField:
            createUserPasswordTextField.becomeFirstResponder()
        default:
            createUserPasswordTextField.resignFirstResponder()
        }
        return true
    }

    @IBAction func onClicktoLoginTap(_ sender: Any) {
        self.dismiss(animated:true, completion: nil)
    }
    
    @IBAction func onUserCreateTap(_ sender: Any) {
        if stateOfCheckBox == true && createUserNameTextField.text != "" && createUserPasswordTextField.text != "" && createUserPasswordTextField.text?.count ?? 0 >= 6 && createUserPasswordTextField.text != "" {
            Auth.auth().createUser(withEmail: createUserEmailTextField.text!, password: createUserPasswordTextField.text!) { authResult, error in
                print("****\(authResult)")
                if authResult == nil {
                    var errorAlert = UIAlertController.init(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                else {
                    print(authResult)
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    var user = ["username": self.createUserEmailTextField.text!, "fullname": self.createUserNameTextField.text!, "itineraries": []] as [String : Any]
                    ref.child("users").child(authResult!.user.uid).updateChildValues(user)
                    print(ref.child("users").child(authResult!.user.uid))
                    //ref.child("itineraries").child("0").setValue(["travellingTo": "Japan"])
                }
            }
            performSegue(withIdentifier: "createUsertoHomeSegue", sender: self)
        } else {
            var errorAlertCheck = UIAlertController.init(title: "Error", message: "Please check to make sure all fields are complete, your password is at least 6 characters, and that you have agreed to the terms", preferredStyle: .alert)
            errorAlertCheck.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(errorAlertCheck, animated: true, completion: nil)
        }
    }
        

    
}

