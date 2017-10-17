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
    
    static func checkUserExists(username: String) -> Bool {
        var userExists = false
        let reference = Database.database().reference().child("users")
        reference.observeSingleEvent(of: .value) { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                if snapshot.hasChild(username) {
                    print("Logged in User has used app before and exists in database with username \(username)")
                    userExists = true
                }
            }
        }
        return userExists
    }
    
    // create post with post class file and user
    // Probably pass in post to with block?
}
