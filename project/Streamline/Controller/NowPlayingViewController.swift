//
//  NowPlayingViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//


import UIKit
import Foundation

//Allows feed view to see the new song in label
protocol NowPlayingProtocol {
    func passLabel(post: Post, index: Int)
    func dismissNowPlaying()
    func updateBlur(dy: CGFloat)
}

//Player controls and detailed info about song
class NowPlayingViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Seekbar variables
    var recognizer: UIPanGestureRecognizer!
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    var sliderEdit: Bool = true
    
    // Delegate/subview
    var subView: NowPlayingView!
    var delegate: NowPlayingProtocol?
    
    override func viewDidLoad() {        
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        // Setups player view
        subView = NowPlayingView(frame: view.frame)
        view.addSubview(subView)
        subView.delegate = self
        
        // Setups seeks bar
        recognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler))
        self.view.addGestureRecognizer(recognizer)
    }
    
    //Manages the seekbar loading for the specific song being played
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        super.viewWillAppear(animated)
        if let index = State.nowPlayingIndex {
            let post = DB.posts[index]
            self.updateSongInformation(post: post, index: index)
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (t) in
                if self.sliderEdit {
                    if SpotifyAPI.player.metadata != nil {
                        if let duration = SpotifyAPI.player.metadata.currentTrack?.duration {
                            let percent = (State.position / duration)
                            self.subView.slider.setValue(Float(percent), animated: true)
                        }
                    }
                }
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //Sets song specific information
    func updateSongInformation(post: Post, index: Int) {
        self.subView.songName.text = post.songTitle
        self.subView.artistName.text = post.artist
        delegate?.passLabel(post: post, index: index)
        post.getImage(withBlock: { (img) in
            self.subView.albumImage.image = img
        })
    }

    // Selectors for seek bar
    func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        if sliderEdit {
            let touchPoint = sender.location(in: self.view?.window)
            
            if sender.state == UIGestureRecognizerState.began {
                initialTouchPoint = touchPoint
            } else if sender.state == UIGestureRecognizerState.changed {
                if touchPoint.y - initialTouchPoint.y > 0 {
                    self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.delegate?.updateBlur(dy: touchPoint.y - initialTouchPoint.y)
                }
            } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
                if touchPoint.y - initialTouchPoint.y > 100 {
                    delegate?.dismissNowPlaying()
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    })
                }
            }
        }
    }
}

//Mangaes the ui elements
extension NowPlayingViewController: NowPlayingViewDelegate {
    
    //Manages buttons presses
    func playButtonPressed() {
        let isPlaying = SpotifyAPI.player.playbackState.isPlaying
        if isPlaying {
            SpotifyAPI.player.setIsPlaying(false, callback: nil)
            subView.playButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        } else {
            SpotifyAPI.player.setIsPlaying(true, callback: nil)
            subView.playButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    func backButtonPressed() {
        delegate?.dismissNowPlaying()
    }
    
    func forwardButtonPressed() {
        let posts = DB.posts
        let toPlayIndex = (State.nowPlayingIndex! + 1) % posts.count
        let post = posts[toPlayIndex]
        self.updateSongInformation(post: post, index: toPlayIndex)
        self.subView.slider.setValue(0, animated: true)
        self.subView.playButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
        State.position = 0
        SpotifyAPI.playPost(post: post, index: toPlayIndex)
    }
    
    func backwardButtonPressed() {
        let posts = DB.posts
        let toPlayIndex = (State.nowPlayingIndex! - 1)
        self.subView.slider.setValue(0, animated: true)
        self.subView.playButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
        State.position = 0
        if toPlayIndex >= 0 {
            let post = posts[toPlayIndex]
            self.updateSongInformation(post: post, index: toPlayIndex)
            SpotifyAPI.playPost(post: post, index: toPlayIndex)
        } else {
            SpotifyAPI.playPost(post: posts[0], index: 0)
        }
    }

    //Manages slider changes
    func sliderChanging() {
        print("Slider changing")
        sliderEdit = false
    }
    
    func sliderNoLongerChanging() {
        print("Slider no longer changing!")
        sliderEdit = true        
        let post = DB.posts[State.nowPlayingIndex!]
        if let currentTrack = SpotifyAPI.player.metadata.currentTrack {
            let duration = currentTrack.duration
            State.position = TimeInterval(subView.slider.value) * duration
            SpotifyAPI.player.seek(to: State.position, callback: nil)
        }
    }
}
