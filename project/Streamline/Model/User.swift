//
//  User.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Haneke

class User {
    var pid        : String!
    var uid        : String!
    var username   : String!
    var imageUrl   : String!
    var timePosted : TimeInterval?
    
    //Username needs to be set from the view controllers
    init(uid: String) {
        self.uid = uid
    }
    
    // Get the users current pid from the database
//    func getPID(withBlock: @escaping () -> ()){
//        DB.retrievePID(uid: self.uid) { (pid) in
//            self.pid = pid
//
//            withBlock()
//        }
//    }
    
    func createPost(pid: String, timePosted: TimeInterval){
        DB.userPost(uid: self.uid, pid: pid, timePosted: timePosted)
        self.timePosted = timePosted
    }
    
    func getProfileImage(withBlock: @escaping (UIImage) -> ()) {
        let url     = URL(string: imageUrl)
        let cache   = Shared.imageCache
        if let url  = url {
            cache.fetch(URL: url).onSuccess({ img in
                withBlock(img)
            })
        }
    }
}
