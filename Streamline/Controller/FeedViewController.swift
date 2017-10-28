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

class FeedViewController: UIViewController {
    var modalView: AKModalView!
    var postCollectionView: UICollectionView!
    var postButton: UIButton!
    var logoutButton: UIButton!
    var discoverLabel: UILabel!
    var nowPlayingButton: UIButton!
    var nowPlayingLabel: UILabel!
    
    // Firebase
    var refHandle: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This is a really bad way of doing this :)
        self.refHandle = Database.database().reference()
        self.refHandle.observe(DataEventType.value, with: { (snapshot) in
            DB.getPosts()
            self.postCollectionView.reloadData()
        })
        setupCollectionView()
        setupBackground()
        setupButton()
        setupLabel()
        setupNowPlaying()
        
        setupSpotify()
        
        DB.getPosts()
        populateFeed()
    }
    
    func populateFeed() {
        postCollectionView.reloadData()
    }
    
    // Setup Functions
    func setupNowPlaying() {
        nowPlayingButton = UIButton(frame: rRect(rx: 0, ry: 609, rw: 375, rh: 60))
        nowPlayingButton.backgroundColor = UIColor.black
        nowPlayingButton.addTarget(self, action: #selector(nowPlayingButtonPressed), for: .touchUpInside)
        view.addSubview(nowPlayingButton)
        
        nowPlayingLabel = UILabel(frame: rRect(rx: 0, ry: 609, rw: 375, rh: 60))
        nowPlayingLabel.textColor = UIColor.white
        nowPlayingLabel.adjustsFontSizeToFitWidth = true
        nowPlayingLabel.font = Constants.averageSans
        view.addSubview(nowPlayingLabel)
    }
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
    func setupBackground() {
        view.backgroundColor = UIColor.white
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // TODO: Change these to match the figma
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        postCollectionView = UICollectionView(frame: rRect(rx: 21, ry: 69, rw: 334, rh: 541), collectionViewLayout: layout)
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "postCell")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.backgroundColor = UIColor.white
        view.addSubview(postCollectionView)
    }
    
    func setupButton() {
        postButton = UIButton(frame: rRect(rx: 328, ry: 26, rw: 28, rh: 27))
        // TODO: Change this to an image that's in the Figma
        postButton.setTitle("P", for: .normal)
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.backgroundColor = UIColor.green
        postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        view.addSubview(postButton)
        
        logoutButton = UIButton(frame: rRect(rx: 15, ry: 26, rw: 74, rh: 22))
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(UIColor(hex: "737171"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        view.addSubview(logoutButton)
    }
    
    func setupLabel() {
        discoverLabel = UILabel(frame: rRect(rx: 94, ry: 20, rw: 187, rh: 44))
        discoverLabel.textColor = UIColor(hex: "311b92")
        discoverLabel.text = "DISCOVER"
        discoverLabel.font = UIFont(name: "Helvetica", size: 30)
        view.addSubview(discoverLabel)
    }
    
    // Selectors
    func postButtonPressed() {
        //self.performSegue(withIdentifier: "toNewPost", sender: self)
        let searchView = SearchView(frame: CGRect(x: view.frame.width * 0.1 , y: view.frame.height * 0.15, width: view.frame.width * 0.8, height: view.frame.height * 0.3), large: true)
        searchView.delegate = self
        modalView = AKModalView(view: searchView)
        modalView.automaticallyCenter = true
        view.addSubview(modalView)
        modalView.show()
    }
    
    func logoutButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func nowPlayingButtonPressed() {
        self.performSegue(withIdentifier: "toNowPlaying", sender: self)
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
        SpotifyAPI.player.playSpotifyURI("spotify:track:" + post.trackId, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            self.nowPlayingLabel.text = "Now playing " + post.songTitle
        })
    }
}

extension FeedViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
}
