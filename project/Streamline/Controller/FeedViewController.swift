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

let BLUR_MAX = CGFloat(0.9)

class FeedViewController: UIViewController {
    var blur: UIVisualEffectView!
    
    //Search View
    var searchView: SearchView!
    var modalView : AKModalView!
    
    //Feed View for UI elements
    var subView: FeedView!
    
    //Music controller view controller
    var nowPlayingVC: NowPlayingViewController?
    
    // Firebase
    var refHandle: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setups the feed view elements
        subView          = FeedView(frame: view.frame)
        subView.delegate = self
        view.addSubview(subView)
        subView.postCollectionView.delegate = self
        subView.postCollectionView.dataSource = self
        
        // Preloading the player view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        nowPlayingVC = storyboard.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController
        nowPlayingVC?.delegate = self
        
        //Initial post loading
        self.refHandle = Database.database().reference()
        self.refHandle.observe(DataEventType.value, with: { (snapshot) in
            DB.getPosts(withBlock : {
                self.subView.postCollectionView.reloadData()
            })
        })
        
        //Setups the spotify player
        setupSpotify()
        
        //Reloads posts
        DB.getPosts(withBlock: {
            self.populateFeed()
        })
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        blur = UIVisualEffectView(effect: blurEffect)
        blur.frame = view.bounds
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.alpha = 0
        view.addSubview(blur)
    }
    
    //Reloading the feed whenever the database changes
    func populateFeed() {
        subView.postCollectionView.reloadData()
    }
    
    //Creates the spotify player
    func setupSpotify() {
        if SpotifyAPI.player == nil {
            SpotifyAPI.player = SPTAudioStreamingController.sharedInstance()
            SpotifyAPI.player!.playbackDelegate = self
            SpotifyAPI.player!.delegate = self
            try! SpotifyAPI.player?.start(withClientId: SpotifyAPI.auth.clientID)
            SpotifyAPI.player!.login(withAccessToken: SpotifyAPI.session.accessToken)
        }
    }
    
    //Creates the modal search view
    func createSearchView(){
        modalView = AKModalView(view: searchView)
        modalView.automaticallyCenter = false
        view.addSubview(modalView)
        modalView.show()
    }
}

//Manages the search view modal
extension FeedViewController: SearchViewDelegate {
    func dismissView() {
        modalView.dismiss()
    }
}

//Manages the collection view
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DB.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
        
        for sub in cell.contentView.subviews {
            sub.removeFromSuperview()
        }
        let post = DB.posts[indexPath.row]
        //let cell = cell as! PostCollectionViewCell
        
        cell.awakeFromNib()
        
        cell.songTitleLabel.text = post.songTitle
        cell.artistLabel.text = post.artist
        cell.postUserLabel.text = post.username
        /*post.getImage { (img) in
         cell.albumImage.image = img
         }*/
        let url = URL(string:post.imageUrl)
        let data = try? Data(contentsOf: url!)
        cell.albumImage.image = UIImage(data: data!)
        return cell
        
        //return cell
    }
    
    /*func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let post = DB.posts[indexPath.row]
        let cell = cell as! PostCollectionViewCell
        cell.songTitleLabel.text = post.songTitle
        cell.artistLabel.text = post.artist
        cell.postUserLabel.text = post.username
        /*post.getImage { (img) in
            cell.albumImage.image = img
        }*/
        let url = URL(string:post.imageUrl)
        let data = try? Data(contentsOf: url!)
        cell.albumImage.image = UIImage(data: data!)
        return cell
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (334 / 375) * view.frame.width, height: 69)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = DB.posts[indexPath.row]
        
        activateAudioSession()
        
        SpotifyAPI.player.playSpotifyURI("spotify:track:" + post.trackId, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            
            //Print any errors
            if (error != nil) {
                print(error!.localizedDescription)
            }
            
            //Check player is active before creating the label
            if (SpotifyAPI.player.loggedIn){
                State.nowPlayingIndex = indexPath.row
                self.changeLabel(post: post, index: State.nowPlayingIndex!)
            }
        })
    }
    
    func changeLabel(post: Post, index: Int) {
        
        //If this is first press change enable all hidden elements
        subView.nowPlayingButton.isHidden = false
        subView.nowPlayingArtist.isHidden = false
        subView.nowPlayingImage.isHidden = false
        subView.nowPlayingLabel.isHidden = false
        
        //Resize collection view so bottom post isn't cut off
        subView.postCollectionView.frame = Utils.rRect(rx: 21, ry: 69, rw: 334, rh: 541)
        
        //Get post info and change label
        let post = DB.posts[index]
        subView.nowPlayingLabel.text = post.songTitle
        subView.nowPlayingArtist.text = post.artist
        
        post.getImage() { (img) in
            self.subView.nowPlayingImage.image = img
        }
    }
}

//Manages spotify player extensions
extension FeedViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    func activateAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        
        let posts = DB.posts
        let toPlayIndex = (State.nowPlayingIndex! + 1) % posts.count
        let post = posts[toPlayIndex]
        
        State.position = 0
        
        //Change the song info in player view
        if let vc = nowPlayingVC {
            vc.updateSongInformation(post: post, index: toPlayIndex)
        }
        
        //Play next song
        SpotifyAPI.playPost(post: post, index: toPlayIndex)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        State.position = position
    }
}

//
extension FeedViewController: NowPlayingProtocol, FeedViewDelegate {
    func passLabel(post: Post, index: Int) {
        changeLabel(post: post, index: index)
    }
    
    func dismissNowPlaying() {
        nowPlayingVC?.dismiss(animated: true)
        UIView.animate(withDuration: 0.4, animations: {
            self.blur.alpha = 0
        })
    }
    
    func updateBlur(dy: CGFloat) {
        let ratio = dy / view.frame.height
        self.blur.alpha = BLUR_MAX - (ratio * BLUR_MAX)
    }
    
    // Selectors
    func postButtonPressed() {
        
        searchView = SearchView(frame: Utils.rRect(rx: 40, ry: 120, rw: 295, rh: 289), large: true)
        searchView.delegate = self
        searchView.searchBar.text = "a"
        searchView.searchSpotify()
        searchView.searchBar.text = ""
        searchView.delegate = self
        
        /* Code to limit user to one song a day and delete user pid if it has been 12 hours */
//        DB.currentUser.getPID {
//            if DB.currentUser.pid == "" {
//                self.createSearchView()
//            } else {
//                //TODO: Check if song is past deadline
//                DB.getSinglePost(pid: DB.currentUser.pid, withBlock: { (post) in
//                    if (Date().timeIntervalSince1970 - post.timePosted >= 43200) {
//                        DB.currentUser.createPost(pid: "")
//                        self.createSearchView()
//                    }
//                })
//            }
        
        //Create search modal
        createSearchView()
    }
    
    //Handles player button pressed
    func nowPlayingButtonPressed() {
        if let index = State.nowPlayingIndex {
            if let npvc = nowPlayingVC {
                self.present(npvc, animated: true, completion: nil)
                UIView.animate(withDuration: 0.4, animations: {
                    self.blur.alpha = BLUR_MAX
                })
            }
        }
    }
    
    //Handles logout
    func logoutButtonPressed() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "SpotifySession")
        
        SpotifyAPI.player.logout()
        self.dismiss(animated: true, completion: nil)
    }
}
