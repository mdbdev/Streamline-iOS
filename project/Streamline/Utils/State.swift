//
//  State.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import MediaPlayer

// Maintains the state of the player
struct State {
    static var nowPlayingIndex: Int?
    static var position: TimeInterval = 0
    static let MPInfoCenter = MPNowPlayingInfoCenter.default()
    static let MPCommandCenter = MPRemoteCommandCenter.shared()
    
    static func updateMP(post: Post) {
        post.getImage { (img) in
            State.MPInfoCenter.nowPlayingInfo = [MPMediaItemPropertyArtist: post.artist,
                                                 MPMediaItemPropertyTitle: post.songTitle,
                                                 MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: img),
                                                 MPNowPlayingInfoPropertyElapsedPlaybackTime: 0]
            State.MPInfoCenter.playbackState = MPNowPlayingPlaybackState.playing
        }
    }
}
