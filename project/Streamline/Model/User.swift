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
    
    init(uid: String,
         pid: String,
         username: String,
         imageUrl: String,
         timePosted: TimeInterval?) {
        self.pid = pid
        self.uid = uid
        self.username = username
        self.imageUrl = imageUrl
        self.timePosted = timePosted
    }
    
    convenience init(uid: String, userDict: [String: Any]) {
        let username = userDict["displayName"] as! String
        let pid = userDict["pid"] as! String
        let imageUrl = userDict["profileImageURL"] as! String
        let timePosted = userDict["timePosted"] as? TimeInterval
        self.init(uid: uid, pid: pid, username: username, imageUrl: imageUrl, timePosted: timePosted)
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
