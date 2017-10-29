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
    
    override func viewDidLoad() {
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = State.nowPlayingIndex {
            DB.posts[index].getImage { (img) in
                self.albumImage.image = img
            }
        }
    }
    
    // Selectors
    func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
