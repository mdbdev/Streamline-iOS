//
//  Post.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Haneke

class Post {
    var pid            : String!
    var uid            : String!
    var username       : String!
    var timePosted     : TimeInterval!
    var trackId        : String!
    var songTitle      : String!
    var artist         : String!
    var imageUrl       : String!
    var profileImageURL: String!
    
    init(uid:           String,
         username:      String,
         timePosted:    TimeInterval,
         trackId:       String,
         songTitle:     String,
         artist:        String,
         imageUrl:      String,
         profileImageURL:  String) {
        self.uid        = uid
        self.username   = username
        self.timePosted = timePosted
        self.trackId    = trackId
        self.songTitle  = songTitle
        self.artist     = artist
        self.imageUrl   = imageUrl
        self.profileImageURL = profileImageURL
    }
    
    convenience init(pid: String, postDict: [String: Any]) {
        let uid         = postDict["uid"]              as! String
        let username    = postDict["displayName"]      as! String
        let imageUrl    = postDict["imageUrl"]         as! String
        let timePosted  = postDict["timePosted"]       as! TimeInterval
        let songTitle   = postDict["songTitle"]        as! String
        let artist      = postDict["artist"]           as! String
        let trackId     = postDict["trackId"]          as! String
        let profImage   = postDict["profileImageURL"]  as! String
        self.init(uid: uid,
                  username: username,
                  timePosted: timePosted,
                  trackId: trackId,
                  songTitle: songTitle,
                  artist: artist,
                  imageUrl: imageUrl,
                  profileImageURL: profImage)
        self.pid = pid
    }
    
    func getImage(withBlock: @escaping (UIImage) -> ()) {
        DispatchQueue.main.async {
            let url = URL(string: self.imageUrl)
            let cache = Shared.imageCache
            if let url = url {
                cache.fetch(URL: url).onSuccess { img in
                    withBlock(img)
                }
            }
        }
    }
}
