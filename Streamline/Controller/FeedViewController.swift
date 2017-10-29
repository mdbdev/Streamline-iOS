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
    var postCollectionView: UICollectionView!
    var postButton: UIButton!
    var logoutButton: UIButton!
    var discoverLabel: UILabel!
    var posts: [Post] = []
    // Spotify
    var player: SPTAudioStreamingController!
    var auth: SPTAuth!
    var session: SPTSession!
    // Firebase
    var refHandle: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This is a really bad way of doing this :)
        self.refHandle = Database.database().reference()
        self.refHandle.observe(DataEventType.value, with: { (snapshot) in
            DB.getPosts(withBlock: { (posts) in
                self.posts = posts
                self.postCollectionView.reloadData()
            })
        })
        setupCollectionView()
        setupBackground()
        setupButton()
        setupLabel()
        
        setupSpotify()
        
        DB.getPosts { (posts) in
            self.posts = posts
            self.populateFeed()
        }
    }
    
    func populateFeed() {
        postCollectionView.reloadData()
    }
    
    // Setup Functions
    func setupSpotify() {
        // Initialize player
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: self.auth.clientID)
            self.player!.login(withAccessToken: self.session.accessToken)
        }
    }
    func setupBackground() {
        view.backgroundColor = Constants.cvBackground
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // TODO: Change these to match the figma
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        postCollectionView = UICollectionView(frame: rRect(rx: 21, ry: 69, rw: 334, rh: 541), collectionViewLayout: layout)
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "postCell")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.backgroundColor = Constants.cvBackground
        view.addSubview(postCollectionView)
    }
    
    func setupButton() {
        postButton = UIButton(frame: rRect(rx: 328, ry: 26, rw: 20, rh: 20))
        // TODO: Change this to an image that's in the Figma
        postButton.setTitle("+", for: .normal)
        postButton.setTitleColor(UIColor(hex: "311b92"), for: .normal)
        postButton.backgroundColor = UIColor.white
    
        
        postButton.backgroundColor = .clear
        postButton.layer.cornerRadius = 1
        postButton.layer.borderWidth = 2
        postButton.layer.borderColor = UIColor(hex: "311b92").cgColor
        
        postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        view.addSubview(postButton)
        
        logoutButton = UIButton(frame: rRect(rx: 15, ry: 30, rw: 74, rh: 22))
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(UIColor(hex: "737171"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        view.addSubview(logoutButton)
    }
    
    func setupLabel() {
        discoverLabel = UILabel(frame: CGRect(x: 0, y: 25, width: view.frame.width, height: 44))

        discoverLabel.textColor = UIColor(hex: "311b92")
        discoverLabel.text = "DISCOVER"
        discoverLabel.textAlignment = .center
        //discoverLabel.font = UIFont(name: "AverageSans-Regular", size: 100)
        
        discoverLabel.font = Constants.averageSans?.withSize(20)
        discoverLabel.font = UIFont.systemFont(ofSize: 30)
        
        view.addSubview(discoverLabel)
    }
    
    // Selectors
    func postButtonPressed() {
        self.performSegue(withIdentifier: "toNewPost", sender: self)
    }
    
    func logoutButtonPressed() {

        self.dismiss(animated: true, completion: nil)
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
        cell.awakeFromNib()
        cell.post = posts[indexPath.row]
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
        let post = posts[indexPath.row]
        self.player.playSpotifyURI("spotify:track:" + post.trackId, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("Playing " + post.songTitle)
            }
        })
    }
}

extension FeedViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
}
