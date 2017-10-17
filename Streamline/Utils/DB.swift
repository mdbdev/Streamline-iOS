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
        let reference = Database.database().reference()
        checkUserExists(username: username) { (userExists) in
            if userExists == false {
                //This is a new user so create the user and assign them a pID of ""
                let userData = ["pid": ""]
                reference.child("users").child(username).setValue(userData)
            } else {
                //This is an old user so the pid is not changed
                print("Logged in User has used app before and exists in database with username \(username)")
            }
        }
    }
    
    //If the user exists return true or false so the pid doesnt get overwritten on login
    static func checkUserExists(username: String, withBlock: @escaping (Bool) -> ()){
        var userExists = false
        let reference = Database.database().reference().child("users")
        reference.observeSingleEvent(of: .value) { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                if snapshot.hasChild(username) {
                    userExists = true
                }
            }
            withBlock(userExists)
        }
    }
    
    //Get the users pid -- method called from the USER model class
    static func retrievePID(username: String, withBlock: @escaping (String) -> ()) {
        let reference = Database.database().reference().child("users").child(username).child("pid")
        reference.observeSingleEvent(of: .value) { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                withBlock(snapshot.value as! String)
            }
        }
    }
    // create post with post class file and user
    // Probably pass in post to with block?
}
