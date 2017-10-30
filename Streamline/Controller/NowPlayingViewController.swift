//
//  NowPlayingViewController.swift
//  Streamline
//
//  Created by Stephen Jayakar on 10/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {
    var backButton: UIButton!
    var albumImage: UIImageView!
    var songName: UILabel!
    var artistName: UILabel!
    
    override func viewDidLoad() {
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = State.nowPlayingIndex {
            let post = DB.posts[index]
            post.getImage { (img) in
                self.albumImage.image = img
                self.songName.text = post.songTitle
                self.artistName.text = post.artist
            }
        }
    }
    
    // Selectors
    func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
