//
//  AddNoteViewController.swift
//  Todo
//
//  Created by Rakesh on 1/17/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddNoteViewController: UIViewController {

    
    var user: FIRUser!
    var ref: FIRDatabaseReference!
    
    @IBOutlet var note: UITextView!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()

    }

    @IBAction func saveNote(_ sender: Any) {
        
        guard let message = note.text else {
            showAlert("Please add some text to save.")
            return
        }
        
        self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(message)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelNote(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(_ message:String){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }

}
