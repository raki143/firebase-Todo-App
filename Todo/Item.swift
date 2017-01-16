//
//  Item.swift
//  Todo
//
//  Created by Rakesh on 1/16/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Item {
    
    var ref: FIRDatabaseReference?
    var title: String?
    
    init (snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, String>
        title = data["title"]! as String
    }
    
}
