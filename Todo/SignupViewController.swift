//
//  SignupViewController.swift
//  Todo
//
//  Created by Rakesh Kumar on 18/12/16.
//  Copyright © 2016 Rakesh Kumar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignupViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        }

    
    @IBAction func didTapSignUp(_ sender: AnyObject) {
        
        guard let email = emailTextField.text, email != "" else {
            showAlert("Please enter valid email address")
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            showAlert("Please enter password")
            return
        }

        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {
            (user, error) in
            if let error = error{
                if let errCode = FIRAuthErrorCode(rawValue: error._code){
                    
                    switch errCode{
                    case .errorCodeInvalidEmail:
                        self.showAlert("Enter a valid Email.")
                    case .errorCodeEmailAlreadyInUse:
                        self.showAlert("Email already in use.")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
                
            }
            self.signIn()
        })
    }
    

    @IBAction func didTapLogin(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func signIn(){
        emailTextField.text = ""
        passwordTextField.text = ""
        performSegue(withIdentifier: "loginFromSignUp", sender: nil)
    }
    
    func showAlert(_ message:String){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
}
