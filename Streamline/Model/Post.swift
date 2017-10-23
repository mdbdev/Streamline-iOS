//
//  Post.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

// TODO: Use Haneke to get the post image!

class Post {
    var pid: String!
    var uid: String!
    var timePosted: Date!
    var trackId: String!
    var songTitle: String!
    var artist: String!
    var imageUrl: String!
    
    init(uid: String,
                     timePosted: Date,
                     trackId: String,
                     songTitle: String,
                     artist: String,
                     imageUrl: String) {
        self.uid = uid
        self.timePosted = timePosted
        self.trackId = trackId
        self.songTitle = songTitle
        self.artist = artist
        self.imageUrl = imageUrl
    }
    
    convenience init(pid: String, postDict: [String: Any]) {
        let uid = postDict["uid"] as! String
        let imageUrl = postDict["imageUrl"] as! String
//        // TODO: This will crash
//        let timePosted = postDict["timePosted"] as! Date
        let songTitle = postDict["songTitle"] as! String
        let artist = postDict["artist"] as! String
        let trackId = postDict["trackId"] as! String
        self.init(uid: uid, timePosted: Date(), trackId: trackId, songTitle: trackId, artist: artist, imageUrl: imageUrl)
        self.pid = pid
    }
    
    func getImage(withBlock: @escaping (UIImage) -> ()) {
        // Do some type of asynch call
    }
}
