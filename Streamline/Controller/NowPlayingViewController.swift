//
//  NowPlayingViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit
import Foundation

class NowPlayingViewController: UIViewController, NowPlayingViewDelegate {
    var recognizer: UIPanGestureRecognizer!
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    var subView: NowPlayingView!
    
    override func viewDidLoad() {
        subView = NowPlayingView(frame: view.frame)
        view.addSubview(subView)
        subView.delegate = self
        recognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler))
        self.view.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = State.nowPlayingIndex {
            let post = DB.posts[index]
            self.updateSongInformation(post: post)
            let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (t) in
                print("timer ticked")
                if let songPosition = State.songPosition {
                    let percent = (songPosition / post.duration)
                    self.subView.slider.setValue(Float(percent), animated: true)
                }
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateSongInformation(post: Post) {
        self.subView.songName.text = post.songTitle
        self.subView.artistName.text = post.artist
        post.getImage(withBlock: { (img) in
            self.subView.albumImage.image = img
        })
    }
    
    // Selectors
    func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}
