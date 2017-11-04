//
//  FeedViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/14/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVFoundation

class FeedViewController: UIViewController {
    var modalView: AKModalView!
    var postCollectionView: UICollectionView!
    var postButton: UIButton!
    var logoutButton: UIButton!
    var discoverLabel: UILabel!
    var nowPlayingButton: UIButton!
    var nowPlayingLabel: UILabel!
    var nowPlayingVC: NowPlayingViewController!
    var searchView: SearchView!
    
    // Firebase
    var refHandle: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Preloading the player view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        nowPlayingVC = storyboard.instantiateViewController(withIdentifier: "NowPlayingViewController") as! NowPlayingViewController
        nowPlayingVC.delegate = self
        self.refHandle = Database.database().reference()
        self.refHandle.observe(DataEventType.value, with: { (snapshot) in
            DB.getPosts()
            self.postCollectionView.reloadData()
        })
        setupUI()
        
        setupSpotify()
        
        DB.getPosts()
        populateFeed()
    }
    
    // TODO: Change the now playing index to match the new data!
    func populateFeed() {
        postCollectionView.reloadData()
    }
    
    // Setup Functions
    func setupSpotify() {
        // Initialize player
        if SpotifyAPI.player == nil {
            SpotifyAPI.player = SPTAudioStreamingController.sharedInstance()
            SpotifyAPI.player!.playbackDelegate = self
            SpotifyAPI.player!.delegate = self
            try! SpotifyAPI.player?.start(withClientId: SpotifyAPI.auth.clientID)
            SpotifyAPI.player!.login(withAccessToken: SpotifyAPI.session.accessToken)
        }
    }
    
    // Selectors
    func postButtonPressed() {
        searchView = SearchView(frame: rRect(rx: 40, ry: 152, rw: 295, rh: 289), large: true)
        searchView.layer.cornerRadius = 20
        searchView.delegate = self
        //self.performSegue(withIdentifier: "toNewPost", sender: self)
//        DB.currentUser.getPID {
//            if DB.currentUser.pid == "" {
        self.modalView = AKModalView(view: self.searchView)
        self.modalView.automaticallyCenter = false
        self.view.addSubview(self.modalView)
        self.modalView.show()
//            }
//        }
        
    }
    
    func logoutButtonPressed() {
        
        SpotifyAPI.player.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    func nowPlayingButtonPressed() {
        if let index = State.nowPlayingIndex {
            self.present(nowPlayingVC, animated: true, completion: nil)
        }
    }
}

extension FeedViewController: SearchViewDelegate {
    func dismissView() {
        modalView.dismiss()
    }
    
    
}
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DB.posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
        cell.awakeFromNib()
        cell.post = DB.posts[indexPath.row]
        cell.updateData()
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Maybe make the height relative too?
        return CGSize(width: (334 / 375) * view.frame.width, height: 69)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Play the song somewhere haha
        // Get the post pointer
        let post = DB.posts[indexPath.row]
        activateAudioSession()
        SpotifyAPI.player.playSpotifyURI("spotify:track:" + post.trackId, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            //print(SpotifyAPI.player.loggedIn)
            if (SpotifyAPI.player.loggedIn){
                self.nowPlayingLabel.text = "Now playing " + post.songTitle
                State.nowPlayingIndex = indexPath.row
            }
        })
    }
}

extension FeedViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    func activateAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func audioStreamingDidSkip(toNextTrack audioStreaming: SPTAudioStreamingController!) {
        print("awlekfjawelkfjawe;lfjkawe;flkajwef")
        self.nowPlayingLabel.text = audioStreaming.metadata.currentTrack?.albumName
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        // TODO: Pick another song to play
        let posts = DB.posts
        let toPlayIndex = (State.nowPlayingIndex! + 1) % posts.count
        let post = posts[toPlayIndex]
        State.position = 0
        if let vc = nowPlayingVC {
            vc.updateSongInformation(post: post)
        }
        SpotifyAPI.playPost(post: post, index: toPlayIndex)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        State.position = position
    }
}

extension FeedViewController: NowPlayingProtocol {
    func passLabel(label: String) {
        self.nowPlayingLabel.text = "Now playing " + label
    }
}
