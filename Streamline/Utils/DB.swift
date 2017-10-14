//
//  DB.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


import Firebase

class DB {
    // Probably add withBlock for asynch
    // Should probably pass in User type into withBlcok
    static func createUser(username: String) {
        var reference = Database.database().reference()
        let userData = ["pid": ""]
        reference.child("users").child(username).setValue(userData)
    }
    
    // create post with post class file and user
    // Probably pass in post to with block?
}
