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
import MediaPlayer

let BLUR_MAX = CGFloat(0.9)

class FeedViewController: UIViewController {
    var blur: UIVisualEffectView!
    var commandCenter: MPRemoteCommandCenter!
    
    // Search View and Menu View
    var menuView    : MenuView!
    var searchView  : SearchView!
    var settingView : SettingView!
    var groupSettingsView   : GroupSettingsView!
    var addGroupView: AddGroupView!
    var groupSelectorView : GroupSelectorView!
    var modalView   : AKModalView!
    
    // Feed View for UI elements
    var subView: FeedView!
    
    //Music controller view controller
    var nowPlayingVC: NowPlayingViewController?
    
    // Firebase
    var refHandle: DatabaseReference!
    
    var numberOfPosts: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        State.MPCommandCenter.pauseCommand.isEnabled = true
        State.MPCommandCenter.pauseCommand.addTarget(self, action: #selector(togglePlaybackState))
        
        State.MPCommandCenter.playCommand.isEnabled = true
        State.MPCommandCenter.playCommand.addTarget(self, action: #selector(togglePlaybackState))
        
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
        
        // Initial post loading
        self.refHandle = Database.database().reference().child("posts")
        self.populateFeed()
        self.refHandle.observe(DataEventType.childAdded) { (snapshot, error) in
            let post = Post(pid: snapshot.key, postDict: snapshot.value as! [String : Any])
            self.subView.postCollectionView.numberOfItems(inSection: 0)
            DB.posts.insert(post, at: 0)
            self.subView.postCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            if State.nowPlayingIndex != nil {
                State.nowPlayingIndex = State.nowPlayingIndex! + 1
            }
        }
        // Setups the spotify player
        setupSpotify()
        
        let blurEffect          = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        blur                    = UIVisualEffectView(effect: blurEffect)
        blur.frame              = view.bounds
        blur.autoresizingMask   = [.flexibleWidth, .flexibleHeight]
        blur.alpha              = 0
        view.addSubview(blur)        
    }
    
    // Reloading the feed whenever the database changes
    func populateFeed() {
        DispatchQueue.main.async {
            DB.getPosts {
                self.numberOfPosts = DB.posts.count
                self.subView.postCollectionView.reloadData()
            }
        }
    }
    
    // Creates the spotify player
    func setupSpotify() {
        if SpotifyAPI.player == nil {
            SpotifyAPI.player = SPTAudioStreamingController.sharedInstance()
            SpotifyAPI.player!.playbackDelegate = self
            SpotifyAPI.player!.delegate = self
            try! SpotifyAPI.player?.start(withClientId: SpotifyAPI.auth.clientID)
            SpotifyAPI.player!.login(withAccessToken: SpotifyAPI.session.accessToken)
        }
    }
    
    func createModalView(uiView: UIView) {
        modalView = AKModalView(view: uiView)
        modalView.automaticallyCenter = false
        view.addSubview(modalView)
        modalView.show()
    }
    
    // Selectors
    @objc
    func togglePlaybackState() {
        SpotifyAPI.togglePlayback()
    }
    
    @objc
    func skipForward() {
        SpotifyAPI.skipForward()
    }
}

// Manages the search view modal
extension FeedViewController: SearchViewDelegate {
    func dismissView() {
        modalView.dismiss()
    }
}

// Manages the collection view
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DB.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
        let post = DB.posts[indexPath.row]
        cell.awakeFromNib()
        post.getImage { (img) in
            UIView.transition(with: cell.albumImage,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { cell.albumImage.image = img },
                              completion: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! PostCollectionViewCell
        let post = DB.posts[indexPath.row]
        
        cell.songTitleLabel.text = post.songTitle
        cell.artistLabel.text = post.artist
        cell.postUserLabel.text = post.username
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (334 / 375) * view.frame.width, height: 69)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = DB.posts[indexPath.row]
        
        activateAudioSession()
        SpotifyAPI.playPost(post: post, index: indexPath.row)
        self.changeLabel(post: post, index: indexPath.row)
    }
    
    func changeLabel(post: Post, index: Int) {
        // If this is first press change enable all hidden elements
        subView.nowPlayingButton.isHidden = false
        subView.nowPlayingArtist.isHidden = false
        subView.nowPlayingImage.isHidden = false
        subView.nowPlayingLabel.isHidden = false
        
        // Resize collection view so bottom post isn't cut off
        subView.postCollectionView.frame = Utils.rRect(rx: 21, ry: 69, rw: 334, rh: 541)
        
        // Get post info and change label
        let post = DB.posts[index]
        subView.nowPlayingLabel.text = post.songTitle
        subView.nowPlayingArtist.text = post.artist
        
        post.getImage() { (img) in
            self.subView.nowPlayingImage.image = img
        }
    }
}

// Manages spotify player extensions
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
        
        // Change the song info in player view
        if let vc = nowPlayingVC {
            vc.updateSongInformation(post: post, index: toPlayIndex)
        }
        
        // Play next song
        SpotifyAPI.playPost(post: post, index: toPlayIndex)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        State.position = position
        if let duration = audioStreaming.metadata.currentTrack?.duration {
            // Modifying percent
            let percent = position / duration
            if let vc = nowPlayingVC {
                vc.updateSlider(percent: percent)
                let position = Int(position)
                if position != 0 {
                    State.MPInfoCenter.nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = Int(position)
                    State.MPInfoCenter.nowPlayingInfo![MPMediaItemPropertyPlaybackDuration] = duration
                }
            }
        }
    }
}

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
        /* Code to limit user to one song a day and delete user pid if it has been 24 hours */
        if let timePosted = DB.currentUser.timePosted {
            if (Date().timeIntervalSince1970 - timePosted > 86400 || DB.currentUser.uid == "1261764229") {
                //self.createSearchView()
                self.createModalView(uiView: searchView)
            } else {
                let alert = Utils.createAlert(warningMessage: "Sorry! You can only post one song a day. Try post again later")
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            //self.createSearchView()
            self.createModalView(uiView: searchView)
        }
    }
    
    func groupsSelectorButtonPressed() {
        groupSelectorView = GroupSelectorView(frame: Utils.rRect(rx: 40, ry: 120, rw: 295, rh: 289), large: true)
        groupSelectorView.delegate = self
        createModalView(uiView: groupSelectorView)
    }
    
    // Handles player button pressed
    func nowPlayingButtonPressed() {
        if let index = State.nowPlayingIndex {
            if let npvc = nowPlayingVC {
                npvc.modalPresentationCapturesStatusBarAppearance = true
                self.present(npvc, animated: true, completion: nil)
                UIView.animate(withDuration: 0.4, animations: {
                    self.blur.alpha = BLUR_MAX
                })
            }
        }
    }
    
    //Handles logout
    func menuButtonPressed() {
        menuView = MenuView(frame: Utils.rRect(rx: 40, ry: 120, rw: 295, rh: 289), large: true)
        menuView.delegate = self
        //createMenuView()
        createModalView(uiView: menuView)
    }
}

extension FeedViewController: MenuViewDelegate {
    func logoutButtonPressed() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "SpotifySession")
        
        SpotifyAPI.player.logout()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func settingButtonPressed() {
        settingView = SettingView(frame: Utils.rRect(rx: 40, ry: 120, rw: 295, rh: 289), large: true)
        settingView.delegate = self
        createModalView(uiView: settingView)
    }
    
    func groupButtonPressed() {
        groupSettingsView = GroupSettingsView(frame: Utils.rRect(rx: 40, ry: 120, rw: 295, rh: 289), large: true)
        groupSettingsView.delegate = self
        createModalView(uiView: groupSettingsView)
    }
}

extension FeedViewController: SettingViewDelegate {
    func setNameButtonPressed() {
        DB.currentUser.username = settingView.usernameTextField.text
        DB.updateUsername(user: DB.currentUser)
        modalView.dismiss()
    }
}

extension FeedViewController: GroupSettingsViewDelegate {
    func createButtonPressed() {
        addGroupView = AddGroupView(frame: Utils.rRect(rx: 40, ry: 120, rw: 295, rh: 289), large: true)
        addGroupView.delegate = self
        createModalView(uiView: addGroupView)
        //DB.createGroup()
    }
}

extension FeedViewController: AddGroupViewDelegate {
    func addGroupButtonPressed() {
        if addGroupView.groupNameTextField.text != nil || addGroupView.groupNameTextField.text != "" {
            DB.createGroup(groupName: self.addGroupView.groupNameTextField.text!)
        }
    }
}

extension FeedViewController: GroupSelectorViewDelegate {
    
}
