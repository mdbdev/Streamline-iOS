//
//  Post.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


class Post {
    var username: String!
    var timePosted: Date!
    var trackId: String!
    var songTitle: String!
    var artist: String!
    var imageUrl: String!
    
    init(pid: String, postDict: [String: Any]) {
        print(postDict)
    }
    
    func getImage(withBlock: @escaping (UIImage) -> ()) {
        // Do some type of asynch call
    }
}
