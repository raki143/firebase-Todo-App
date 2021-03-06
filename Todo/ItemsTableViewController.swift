//
//  ItemsTableViewController.swift
//  Todo
//
//  Created by Rakesh on 1/16/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ItemsTableViewController: UITableViewController {

    var user: FIRUser!
    var items = [Item]()
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        startObservingDatabase()
        
    }

    func startObservingDatabase () {
        databaseHandle = ref.child("users/\(self.user.uid)/items").observe(.value, with: { (snapshot) in
            var newItems = [Item]()
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! FIRDataSnapshot)
                newItems.append(item)
            }
            
            self.items = newItems
            self.tableView.reloadData()
            
        })
    }
    
    @IBAction func didTapAddItem(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addNoteVC = storyboard.instantiateViewController(withIdentifier: "AddNote")
        present(addNoteVC, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapSignOut(_ sender: Any) {
        
        let firebaseAuth = FIRAuth.auth()
        do{
            try firebaseAuth?.signOut()
            dismiss(animated: true, completion: nil)
        }catch let signOutError as NSError{
            print("signout error : \(signOutError.localizedDescription) ")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        print(item.title!)
    }
    
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
            // Delete the row from the data source
          //  tableView.deleteRows(at: [indexPath], with: .fade)
            let item = items[indexPath.row]
            item.ref?.removeValue()
            
        }
    }
    

    deinit {
        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
    }

}
