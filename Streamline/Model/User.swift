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
    var username: String!
    
    //Username needs to be set from the view controllers
    init(uid: String) {
        self.uid = uid
    }
    
    //Get the users current pid from the database
    func getPID(){
        DB.retrievePID(username: self.username) { (pid) in
            self.pid = pid
        }
    }
}
