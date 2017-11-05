//
//  SpotifyAPI.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 10/19/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation

struct SpotifyAPI {
    static let clientID = "e4603453585849a6ad176d0fb81acd97"
    static let redirectURL = "Streamline://returnAfterLogin"
    static var session: SPTSession!
    static var player: SPTAudioStreamingController!
    static var auth: SPTAuth!
    
    //Play the post with the player
    static func playPost(post: Post, index: Int) {
        player.playSpotifyURI("spotify:track:" + post.trackId, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            State.nowPlayingIndex = index
        })
    }
}
