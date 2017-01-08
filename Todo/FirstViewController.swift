//
//  FirstViewController.swift
//  Todo
//
//  Created by Rakesh Kumar on 18/12/16.
//  Copyright © 2016 Rakesh Kumar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func signOut(_ sender: AnyObject) {
        
        let firebaseAuth = FIRAuth.auth()
        do{
            try firebaseAuth?.signOut()
            dismiss(animated: true, completion: nil)
        }catch let signOutError as NSError{
            print("signout error : \(signOutError.localizedDescription) ")
        }
        
    }

}
