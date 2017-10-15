//
//  User.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


class User {
    
    //User Name
    var pid: String!
    var uid: String!
    var userFromFacebook: Bool!
    var username: String!
    
    init(uid: String) {
        self.uid = uid
        
        //If the uid is a string that means that the user is from facebook
        if Int(uid) == nil {
            userFromFacebook = false
            self.username = uid
        } else {
            userFromFacebook = true
        }
    }
}
