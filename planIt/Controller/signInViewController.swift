//
//  saveViewController.swift
//  planIt
//
//  Created by Tracy Chen on 5/3/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class signInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signInUsernameTextField: UITextField!
    @IBOutlet weak var signInPasswordTextField: UITextField!
    @IBOutlet weak var siginInLabel: UIButton!
    @IBOutlet weak var passwordLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        siginInLabel.layer.cornerRadius = 20
        passwordLabel.layer.cornerRadius = 20
        signInUsernameTextField.delegate = self
        signInPasswordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signInViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor.systemTeal.cgColor, UIColor.white.cgColor]
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case signInUsernameTextField:
            signInPasswordTextField.becomeFirstResponder()
        default:
            signInPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func onSignInTap(_ sender: Any) {
        Auth.auth().signIn(withEmail: signInUsernameTextField.text!, password: signInPasswordTextField.text!) { authResult, error in
            if authResult == nil {
                var errorAlert = UIAlertController.init(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
            else {
                UserDefaults.standard.set(authResult?.user.uid, forKey: "userID")
                self.performSegue(withIdentifier: "loginToHomeSegue", sender: self)
            }
        }

}
    
    @IBAction func onCreateUserTap(_ sender: Any) {
        performSegue(withIdentifier: "createUserSegue", sender: self)
    }

}

