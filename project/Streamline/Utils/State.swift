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
    static var paused: Bool = false
    static var position: TimeInterval = 0
    static let commandCenter = MPNowPlayingInfoCenter.default()
    
    static func updateMP(post: Post) {
        post.getImage { (img) in
            State.commandCenter.nowPlayingInfo = [MPMediaItemPropertyArtist: post.artist,
                                                  MPMediaItemPropertyTitle: post.songTitle,
                                                  MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: img)]
            State.commandCenter.playbackState = MPNowPlayingPlaybackState.playing
        }
    }
}
