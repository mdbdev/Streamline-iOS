//
//  Post.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Haneke

class Post {
    var pid: String!
    var uid: String!
    var username: String!
    var timePosted: Date!
    var trackId: String!
    var songTitle: String!
    var artist: String!
    var imageUrl: String!
    var duration: TimeInterval
    
    init(uid: String,
         username: String,
         timePosted: Date,
         trackId: String,
         songTitle: String,
         artist: String,
         imageUrl: String,
         duration: TimeInterval) {
        self.uid = uid
        self.username = username
        self.timePosted = timePosted
        self.trackId = trackId
        self.songTitle = songTitle
        self.artist = artist
        self.imageUrl = imageUrl
        self.duration = duration
    }
    
    convenience init(pid: String, postDict: [String: Any]) {
        let uid = postDict["uid"] as! String
        let username = postDict["username"] as! String
        let imageUrl = postDict["imageUrl"] as! String
//        // TODO: This will crash
//        let timePosted = postDict["timePosted"] as! Date
        let songTitle = postDict["songTitle"] as! String
        let artist = postDict["artist"] as! String
        let trackId = postDict["trackId"] as! String
        let duration = postDict["duration"] as! TimeInterval
        self.init(uid: uid, username: username, timePosted: Date(), trackId: trackId, songTitle: songTitle, artist: artist, imageUrl: imageUrl, duration: duration)
        self.pid = pid
    }
    
    func getImage(withBlock: @escaping (UIImage) -> ()) {        
        let url = URL(string: imageUrl)
        let cache = Shared.imageCache
        if let url = url {
            cache.fetch(URL: url).onSuccess({ img in
                withBlock(img)
            })
        }
    }
}
