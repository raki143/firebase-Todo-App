//
//  ViewController.swift
//  Todo
//
//  Created by Rakesh Kumar on 18/12/16.
//  Copyright © 2016 Rakesh Kumar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        super.viewDidAppear(animated)
        if let _ = FIRAuth.auth()?.currentUser {
            self.signIn()
        }
    }

    @IBAction func didTapSignIn(_ sender: AnyObject) {
        
        guard let email = emailField.text, email != "" else {
            showAlert("Please enter valid email address")
            return
        }
        guard let password = passwordField.text, password != "" else {
            showAlert("Please enter password")
            return
        }
        
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {
            (user,error) in
            
                if let error = error {
                    if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .errorCodeUserNotFound:
                            self.showAlert("User account not found. Try registering")
                        case .errorCodeWrongPassword:
                            self.showAlert("Incorrect username/password combination")
                        default:
                            self.showAlert("Please Enter your valid credentials")
                        }
                    }
                    return
                }
        
            self.signIn()
        })
    }
    
    
    @IBAction func requestResetPassword(_ sender: AnyObject) {
        
        let prompt = UIAlertController(title: "Reset Password", message: "Enter your email Id", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: { (action) in
            
            let userInput = prompt.textFields![0].text
            
            guard let user = userInput, !user.isEmpty else{
                return
            }
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: user, completion: { (error) in
                if let error = error {
                    if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .errorCodeUserNotFound:
                            DispatchQueue.main.async {
                                self.showAlert("User account not found. Try registering")
                            }
                        default:
                            DispatchQueue.main.async {
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    return
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("You'll receive an email shortly to reset your password.")
                    }
                }
            })
        })
    
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    func signIn(){
        emailField.text = ""
        passwordField.text = ""
        performSegue(withIdentifier: "loginFromSignIn", sender: nil)
    }
    
    func showAlert(_ message:String){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }

}

