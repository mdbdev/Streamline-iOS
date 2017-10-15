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
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBackground()
        setupButton()
        /*DB.getPosts { (postData) in
            self.posts = postData
            updatePosts()
        }*/
    }
    
    func updatePosts() {
        
    }
    
    // Setup Functions
    func setupCollectionView() {
        postCollectionView = UICollectionView(frame: view.frame)
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "postCell")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        view.addSubview(postCollectionView)
    }
    
    func setupBackground() {
    }
    
    func setupButton() {
        postButton = UIButton(frame: CGRect(x: view.frame.width * 0.8, y: view.frame.height * 0.05, width: 40, height: 40))
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.backgroundColor = UIColor.green
        postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        view.addSubview(postButton)
    }
    
    // Selectors
    func postButtonPressed() {
        print("post button pressed")
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath)
        cell.awakeFromNib()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Mmooo")
    }
}
